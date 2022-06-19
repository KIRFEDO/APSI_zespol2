
document.addEventListener('DOMContentLoaded', function(){

    $('#project').on('change',function(){

        if($('#project').is('disabled')){
         return;
        }
        else if ($('#project').val() === "") {
            clearTaskOptions();
            clearDocumentOptions();
            clearErrorOptions();
            return;
        } else {
            $.ajax({
                url: '/tasks/' + $('#project').val(),
                success: function(data) {
                    clearTaskOptions();
                    JSON.parse(data).forEach(element => {
                            $("#task").append(
                            $("<option></option>")
                            .attr("value", element[0])
                            .text(element[1])
                        );
                    })
                }
            });
            $.ajax({
                url: '/documents/' + $('#project').val(),
                success: function(data) {
                    clearDocumentOptions();
                    JSON.parse(data).forEach(element => {
                            $("#document").append(
                            $("<option></option>")
                            .attr("value", element[0])
                            .text(element[1])
                        );
                    })
                }
            });
            $.ajax({
                url: '/errors/' + $('#project').val(),
                success: function(data) {
                    clearErrorOptions();
                    JSON.parse(data).forEach(element => {
                            $("#error").append(
                            $("<option></option>")
                            .attr("value", element[0])
                            .text(element[1])
                        );
                    })
                }
            });
        }

    });

    $('#project').change();

    function clearTaskOptions() {
        $("#task").empty()
        let opt = document.createElement('option');
        opt.value = "";
        opt.innerHTML = "Wybierz zadanie";
        $('#task').append(opt);
    }

    function clearDocumentOptions() {
        $("#document").empty()
        let opt = document.createElement('option');
        opt.value = "";
        opt.innerHTML = "Wybierz dokument";
        $('#document').append(opt);
    }

    function clearErrorOptions() {
        $("#error").empty()
        let opt = document.createElement('option');
        opt.value = "";
        opt.innerHTML = "Wybierz błąd";
        $('#error').append(opt);
    }
});