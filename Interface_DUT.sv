////definicion de los tipos de transacciones
//puede ser con un enum
typedef enum(Trans_paquete_comun, Trans_todos_a_todos, Trans_broadcast, Trans_dispsitivo_especifico, Trans_id_invalido, Trans_ceros) tipo_trans;

//esta clase es un objeto que se encargada de definir las trasacciones que entran y salen del bus
class Interface_DUT #(parameter WITDH = 16, MAX_RETARDO=10, DISPOSITIVOS=16);
//entradas
  rand int retardo;
  rand bit [WIDTH-1 :0] D_push;
  rand int id;
//salidas
  int salida_id;
  bit [WIDTH-1 :0]  D_pop;
  int tiempo_retardo;
//se defienen las limitaciones
  constraint const_id {id<DISPOSITIVOS, id>2 };
  constraint const_retraso {retraso<MAX_RETARDO, retraso>0 };

  function new (int new_retardo=0, bit [WIDTH-1 :0] new_D_push=0, int new_id=2 );
  this.retardo = new_retardo;
  this.D_push = new_D_push;
  this.id = new_id;
  end function
endclass 
//
