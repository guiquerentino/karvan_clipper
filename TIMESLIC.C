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
 * Função.: Esta função põe um "gancho" na rotina de manipulação de teclado, acionada para
 *          tratar todos os eventos deste. Sendo assim, no momento de ociosidade, quando o
 *          antigo manipulador for acionado para qualquer otimização em background, o novo
 *          manipulador será chamado antes, e este liberará o tempo de CPU, para então dar
 *          o controle ao antigo manipulador.
 *          O parâmetro nDelay (opcional) serve para especificar, a grosso modo, qual será
 *          a taxa de execução da interrupção de liberação da CPU.
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


// Estrutura de dados para a chamada de interrupção no modo real
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
 * Função.: Liberar para o sistema operacional as fatias de tempo utilizadas pelo programa
 *          para otimizações em background, em ciclos de tempo normalmente ociosos.
 *          Esta liberação ocorrerá sempre que o antigo manipulador de teclado for chamado
 *          e o contador "Delay" for reciclado. E, conforme a configuração deste contador,
 *          a função de liberação do uso da CPU será executada mais ou menos vezes. Apenas
 *          a prática dirá o valor ideal. Mas o valor default parece ser bem apropriado.
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
                 mov  es,ax                       // o endereço da tabela
                 mov  di,offset RealCall          // carregar o offset inicial
                 push es                          // salvar os dois...
                 push di                          // registradores
                 mov  cx,StructSize               // tamanho da tabela
                 xor  ax,ax                       // caractere de preenchimento
                 cld                              // condição de incremento para DF
                 rep  stosb                       // limpar a tabela
                 pop  di                          // recuperar o endereço...
                 pop  es                          // da tabela
                                                  //
                 mov  ax,0x0300                   // simulação de interrupção no modo real
                 mov  bh,0                        // reservado: deve ser zero
                 mov  bl,0x2F                     // interrupção do modo real
                 xor  cx,cx                       // tamanho da tabela devolvida
                 mov  word ptr RealCall.EAX,1680h // função modo real de liberação da CPU
                 int  0x31                        // interrupção DPMI
                 }
        }
        else {
            asm {mov ax,0x1680                    // serviço para a liberação da CPU
                 int 0x2F                         // chamada à interrupção multiplex
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
