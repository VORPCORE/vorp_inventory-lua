window.addEventListener('message', function (event) {

    
    
    if(event.data.action == "updateStatusHud") {

        if(event.data.money) {
            $("#money-value").text(event.data.money.toFixed(2) + " ").css("color" , "#ffffff");
          
        }

        if(event.data.gold) {
            $("#gold-value").text(event.data.gold.toFixed(2) + " ").css("color" , "#ffffff");
           
        }

        if(event.data.id) {
            $("#id-value").text(event.data.id + "ID ").css("color" , "#ffffff");
            
        }

    }
});

//for gold cash and ID
