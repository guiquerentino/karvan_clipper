/*
 *
 *  FreeTSlice()
 *  -------------------------------
 *  (o) 09/2002, Paulo Buzinello
 *               Londrina/PR
 *               Brasil
 *               pbuzinello@usa.com
 *  -------------------------------
 *
 *  Baseado no trabalho original de
 *  Dmitry A. Steklenev (DOSIDLE.C)
 *
 *
 */


#include <extend.api>

extern void *_evKbdEntry;
static void  _IdleGenerate(void);


/*****************************************************************************************
 * Sintaxe: FreeTSlice([nDelay])
 * Fun��o.: Esta fun��o p�e um "gancho" na rotina de manipula��o de teclado, acionada para
 *          tratar todos os eventos deste. Sendo assim, no momento de ociosidade, quando o
 *          antigo manipulador for acionado para qualquer otimiza��o em background, o novo
 *          manipulador ser� chamado antes, e este liberar� o tempo de CPU, para ent�o dar
 *          o controle ao antigo manipulador.
 *          O par�metro nDelay (opcional) serve para especificar, a grosso modo, qual ser�
 *          a taxa de execu��o da interrup��o de libera��o da CPU.
 ****************************************************************************************/
static int   dpmiFound = 0;
static int   StdDelay     ;
static void *_stKbdEntry  ;

CLIPPER FreeTSlice(void) {
    static int Hooked = 0;
    StdDelay = (_parinfo(0)? _parni(1): 20);

    if (!Hooked) {
        asm {mov ax,0x1686
             int 0x2F
             or  ax,ax
             jne Hook
             }
        dpmiFound = 1;

        Hook:
        Hooked      = 1;
        _stKbdEntry = _evKbdEntry;
        _evKbdEntry = (void*)&_IdleGenerate;
    }
}


// Estrutura de dados para a chamada de interrup��o no modo real
typedef unsigned long  DWORD;
typedef int            _WORD;

static struct _RealCall {
    DWORD EDI; DWORD ESI;
    DWORD EBP; DWORD Reserved;
    DWORD EBX; DWORD EDX;
    DWORD ECX; DWORD EAX;

    _WORD FLG;
    _WORD  ES; _WORD DS;
    _WORD  FS; _WORD GS;
    _WORD  IP; _WORD CS;
    _WORD  SP; _WORD SS;
} RealCall;


/*****************************************************************************************
 * Sintaxe: _IdleGenerate()
 * Fun��o.: Liberar para o sistema operacional as fatias de tempo utilizadas pelo programa
 *          para otimiza��es em background, em ciclos de tempo normalmente ociosos.
 *          Esta libera��o ocorrer� sempre que o antigo manipulador de teclado for chamado
 *          e o contador "Delay" for reciclado. E, conforme a configura��o deste contador,
 *          a fun��o de libera��o do uso da CPU ser� executada mais ou menos vezes. Apenas
 *          a pr�tica dir� o valor ideal. Mas o valor default parece ser bem apropriado.
 ****************************************************************************************/
static void _IdleGenerate() {
    static int Delay = 0;
    int StructSize = sizeof(RealCall);

    if (++Delay==StdDelay) {
        Delay = 0;

        asm {push ax
             push bx
             push cx
             push dx
             push di
             push si
             push ds
             push es
             push bp
             }

        if (dpmiFound) {
            asm {mov  ax,seg RealCall             // montar o registrador ES com...
                 mov  es,ax                       // o endere�o da tabela
                 mov  di,offset RealCall          // carregar o offset inicial
                 push es                          // salvar os dois...
                 push di                          // registradores
                 mov  cx,StructSize               // tamanho da tabela
                 xor  ax,ax                       // caractere de preenchimento
                 cld                              // condi��o de incremento para DF
                 rep  stosb                       // limpar a tabela
                 pop  di                          // recuperar o endere�o...
                 pop  es                          // da tabela
                                                  //
                 mov  ax,0x0300                   // simula��o de interrup��o no modo real
                 mov  bh,0                        // reservado: deve ser zero
                 mov  bl,0x2F                     // interrup��o do modo real
                 xor  cx,cx                       // tamanho da tabela devolvida
                 mov  word ptr RealCall.EAX,1680h // fun��o modo real de libera��o da CPU
                 int  0x31                        // interrup��o DPMI
                 }
        }
        else {
            asm {mov ax,0x1680                    // servi�o para a libera��o da CPU
                 int 0x2F                         // chamada � interrup��o multiplex
                 }
        }
        asm {pop bp
             pop es
             pop ds
             pop si
             pop di
             pop dx
             pop cx
             pop bx
             pop ax
             }
    }

    asm {mov sp,bp                    //
         pop bp                       //
         jmp dword ptr ds:_stKbdEntry // devolver o controle ao antigo manipulador
         }
}
