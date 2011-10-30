function zmenf(obr,nazev) {
	if(document.images) { 
	var i=0;
	self.document.getElementById([zmenf.arguments[i]]).setAttribute('src', eval([zmenf.arguments[i+1]] + ".src")); 
	}
}
function plnit(hodnota) {
	if (hodnota == 1)
		{document.login.username.value = "full"; document.login.password.value = "full";}
	if (hodnota == 2)
		{document.login.username.value = "test"; document.login.password.value = "test";}
	if (hodnota == 3)
		{document.login.username.value = "test512"; document.login.password.value = "test512";}
	if (hodnota == 4)
		{document.login.username.value = "test100"; document.login.password.value = "test100";}
	return document.login.username.value, document.login.password.value;
}
function nahoda()
    {
	pomPole[0] = Math.ceil(4*Math.random());

    for (i = 1; i <= 3; i++)
       {    var cisloPouzito = true;
             while (cisloPouzito)
             	{ pomPole[i] = Math.ceil(4*Math.random());
                      for (x = 0; x < i; x++)
                         { cisloPouzito = (pomPole[x] == pomPole[i]);
                            if (cisloPouzito) {break; }; }
                 }
     }
	
	for (i = 1; i < 5; i++)
	  {
	  if (pomPole[i-1] == 1) {
	  	if (i == 1) {eval("imga.src='img/ch.jpg';");};
	  	if (i == 2) {eval("imgb.src='img/ch.jpg';");};
	  	if (i == 3) {eval("imgc.src='img/ch.jpg';");};
	  	if (i == 4) {eval("imgd.src='img/ch.jpg';");};
		}
	  }
 }
 
if(document.images) {
	var blnk=new Image();	blnk.src="img/blank.jpg";
	var imga=new Image();	imga.src="img/eu.jpg";
	var imgb=new Image();	imgb.src="img/eu.jpg";
	var imgc=new Image();	imgc.src="img/eu.jpg";
	var imgd=new Image();	imgd.src="img/eu.jpg";
	
	pomPole = new Array(4);
}
nahoda();
