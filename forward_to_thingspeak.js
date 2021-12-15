let serial_string = document.getElementsByClassName('code_panel__serial__content__text js-code_panel__serial__text js-code_editor__serial-monitor__content')[0].textContent

function forwardValue(v) {
   lastRow = v.split('\n').at(-2);
   console.log(lastRow);
   lastRow = lastRow.split(' ')
   fill = lastRow.at(0);
   gas = lastRow.at(2);
   diff = lastRow.at(3);

   var xhr = new XMLHttpRequest();
   url = `https://api.thingspeak.com/update.json?api_key=LUZEUMK6PB1B7JQ5&field1=${fill}&field2=${diff}&field3=${gas}`;
   xhr.open("GET", url, false );
   xhr.send(null);
}

function checkValue()
{
    let currentValue = document.getElementsByClassName('code_panel__serial__content__text js-code_panel__serial__text js-code_editor__serial-monitor__content')[0].textContent
    if (currentValue !== serial_string) {
       serial_string = currentValue
       forwardValue(serial_string)
    }
    setTimeout(checkValue, 5000);
}

// primera llamada

setTimeout(checkValue, 5000);   