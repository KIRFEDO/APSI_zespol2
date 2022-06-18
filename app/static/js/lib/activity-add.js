
document.addEventListener('DOMContentLoaded', function(){

    $('#project').on('change',function(){

        if($('#project').is('disabled')){
         return;
        }
        else if ($('#project').val() === "") {
            clearTaskOptions();
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
                            .text(element[1]);
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

});