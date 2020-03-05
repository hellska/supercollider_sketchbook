// Comunicazione Hydra 2 SC
~dirt = SuperDirt.start(2, ~pserver, 4);

// Reinviare eventi da Superdirt a Hydra
// impostare questo codice
(
n = NetAddr("127.0.0.1", 3333);
~dirt.receiveAction = { |e|
	if ( (e.at(\s)==\bd),
		{ n.sendMsg("/bd", e.at(\cycle));}, {}
	);
};
)

/* Definire questa funzione in Hydra


msg.setPort(3333)
msg.on('/bd', (args) => {
  console.log(args)
})

// definire variabile

bd = 0;

msg.setPort(3333)
msg.on('/bd', (args) => {
  console.log(args[0]%1)
  bd = args[0]%1
})

osc()
.scale(()=>bd+1)
.out()

solid().out()
*/