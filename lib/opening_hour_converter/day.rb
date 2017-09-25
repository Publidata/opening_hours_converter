
# Day.prototype.getAsMinutesArray = function() {
#   //Create array with all values set to false
#   //For each minute
#   var minuteArray = [];
#   for (var minute = 0; minute <= MINUTES_MAX; minute++) {
#     minuteArray[minute] = false;
#   }

#   //Set to true values where an interval is defined
#   for(var id=0, l=this._intervals.length; id < l; id++) {
#     if(this._intervals[id] != undefined) {
#       var startMinute = null;
#       var endMinute = null;

#       if(
#         this._intervals[id].getStartDay() == this._intervals[id].getEndDay()
#         || (this._intervals[id].getEndDay() == DAYS_MAX && this._intervals[id].getTo() == MINUTES_MAX)
#       ) {
#         //Define start and end minute regarding the current day
#         startMinute = this._intervals[id].getFrom();
#         endMinute = this._intervals[id].getTo();
#       }

#       //Set to true the minutes for this day
#       if(startMinute != null && endMinute != null){
#         for(var minute = startMinute; minute <= endMinute; minute++) {
#           minuteArray[minute] = true;
#         }
#       }
#       else {
#         console.log(this._intervals[id].getFrom()+" "+this._intervals[id].getTo()+" "+this._intervals[id].getStartDay()+" "+this._intervals[id].getEndDay());
#         throw new Error("Invalid interval");
#       }
#     }
#   }

#   return minuteArray;
# };
