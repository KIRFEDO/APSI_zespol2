(function($) {

	"use strict";

	document.addEventListener('DOMContentLoaded', function(){

    var today = new Date(),
        year = today.getFullYear(),
        month = today.getMonth(),
        monthTag =["Styczeń","Luty","Marzec","Kwiecień","Maj","Czerwiec","Lipiec","Sierpień",
                        "Wrzesień","Październik","Listopad","Grudzień"],
        day = today.getDate(),
        days = document.getElementsByTagName('td'),
        selectedDay,
        setDate,
        daysLen = days.length;


    var that;

    function Calendar(selector, options) {
        this.options = options;
        this.hours = new Map();
        this.draw();
        that = this;
    }


    
    Calendar.prototype.draw  = function() {
        this.getCookie('selected_day');
        this.getOptions();
        this.drawDays();
        var that = this,
            reset = document.getElementById('reset'),
            pre = document.getElementsByClassName('pre-button'),
            next = document.getElementsByClassName('next-button');
            
            pre[0].addEventListener('click', function(){that.preMonth(); });
            next[0].addEventListener('click', function(){that.nextMonth(); });
            reset.addEventListener('click', function(){that.reset(); });
        while(daysLen--) {
            days[daysLen].addEventListener('click', function(){that.clickDay(this); });
        }
    };
    
    Calendar.prototype.drawHeader = function(e) {

        var headDay = document.getElementsByClassName('head-day'),
            headMonth = document.getElementsByClassName('head-month'),
            headDesc = document.getElementsByClassName('head-description');

            if (e !== undefined && isNaN(e)) {
                e = e.substr(0, e.indexOf('</')).substr(3);
            }

            e?headDay[0].innerHTML = e : headDay[0].innerHTML = day;
            headMonth[0].innerHTML = monthTag[month] + " - " + year;

            if(this.hours.get(parseInt(e))) {
                headDesc[0].innerHTML = "<p style=\"color: white; font-size: 20px;\">Zarejestrowano " +
                        this.hours.get(parseInt(e)) +" h</p>";
            } else {
                headDesc[0].innerHTML = "<p style=\"color: white; font-size: 20px;\">Brak zarejestrowanych godzin</p>";
            }

     };
    
    Calendar.prototype.drawDays = function() {

        $.ajax({
            url: '/activities/info',
            success: function(data) {
                that.placeDays(JSON.parse(data));
            }
        });
    }

    Calendar.prototype.placeDays = function(activities) {

        this.hours = new Map();

        activities.forEach(element => {

            var dt = new Date(element.date);
            if ((dt.getFullYear() === year) && (dt.getMonth() === month) &&
                    element.supervisor_approved !== false) {

                if (this.hours.get(dt.getDate()) === undefined) {
                    this.hours.set(dt.getDate(), element.time);
                } else {
                    this.hours.set(dt.getDate(), element.time + this.hours.get(dt.getDate()));
                }

            }

        });

        var startDay = new Date(year, month, 0).getDay(),

            nDays = new Date(year, month + 1, 0).getDate(),

            n = startDay;


        for(var k = 0; k <42; k++) {
            days[k].innerHTML = '';
            days[k].id = '';
            days[k].className = '';
        }

        for(var i  = 1; i <= nDays ; i++) {
            days[n].innerHTML = '<b>' + i + '</b><br><small>&nbsp';

            if (this.hours.get(n-1) !== undefined) {
                days[n].innerHTML += this.hours.get(n-1) + 'h';
            }
            days[n].innerHTML += '</small>';

            n++;
        }
        
        for(var j = 0; j < 42; j++) {
            if(days[j].innerHTML === ""){
                
                days[j].id = "disabled";
                
            }else if(j === day + startDay - 1){
                if((this.options && (month === setDate.getMonth()) && (year === setDate.getFullYear())) || (!this.options && (month === today.getMonth())&&(year===today.getFullYear()))){
                    this.drawHeader(day);
                    days[j].id = "today";
                }
            }
            if(selectedDay){
                if((j === selectedDay.getDate() + startDay - 1)&&(month === selectedDay.getMonth())&&(year === selectedDay.getFullYear())){
                days[j].className = "selected";
                this.drawHeader(selectedDay.getDate());
                }
            }
        }
    };
    
    Calendar.prototype.clickDay = function(o) {
        var selected = document.getElementsByClassName("selected"),
            len = selected.length;
        if(len !== 0){
            selected[0].className = "";
        }
        o.className = "selected";
        selectedDay = new Date(year, month, o.innerHTML);
        this.drawHeader(o.innerHTML);
        this.setCookie('selected_day', 1);
        
    };
    
    Calendar.prototype.preMonth = function() {
        if(month < 1){ 
            month = 11;
            year = year - 1; 
        }else{
            month = month - 1;
        }
        this.drawHeader(1);
        this.drawDays();
    };
    
    Calendar.prototype.nextMonth = function() {
        if(month >= 11){
            month = 0;
            year =  year + 1; 
        }else{
            month = month + 1;
        }
        this.drawHeader(1);
        this.drawDays();
    };
    
    Calendar.prototype.getOptions = function() {
        if(this.options){
            var sets = this.options.split('-');
                setDate = new Date(sets[0], sets[1]-1, sets[2]);
                day = setDate.getDate();
                year = setDate.getFullYear();
                month = setDate.getMonth();
        }
    };
    
     Calendar.prototype.reset = function() {
         month = today.getMonth();
         year = today.getFullYear();
         day = today.getDate();
         this.options = undefined;
         this.drawDays();
     };
    
    Calendar.prototype.setCookie = function(name, expiredays){
        if(expiredays) {
            var date = new Date();
            date.setTime(date.getTime() + (expiredays*24*60*60*1000));
            var expires = "; expires=" +date.toGMTString();
        }else{
            var expires = "";
        }
        document.cookie = name + "=" + selectedDay + expires + "; path=/";
    };
    
    Calendar.prototype.getCookie = function(name) {
        if(document.cookie.length){
            var arrCookie  = document.cookie.split(';'),
                nameEQ = name + "=";
            for(var i = 0, cLen = arrCookie.length; i < cLen; i++) {
                var c = arrCookie[i];
                while (c.charAt(0)==' ') {
                    c = c.substring(1,c.length);
                    
                }
                if (c.indexOf(nameEQ) === 0) {
                    selectedDay =  new Date(c.substring(nameEQ.length, c.length));
                }
            }
        }
    };
    var calendar = new Calendar();
    
        
}, false);

})(jQuery);
