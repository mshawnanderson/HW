function checkData()
{
        var msgs=new Array();
        var nonEmpty=new Array("firstName","lastName","address1","city","state","zip","country");
        for (var i=0;i<nonEmpty.length;i++)
        {
                var val = document.getElementById(nonEmpty[i]).value;
                // First - all but address 2 need data
                if (val == "" || val == null)
                {
                        msgs.push("Missing Data for " + nonEmpty[i] + ".");
                }
                if (nonEmpty[i] == "country")
                {
                        if ((val != "") && (val != "US"))
                        {
                                msgs.push("Incorrect Data Format for " + nonEmpty[i] + ".");
                        }
                }
                if (nonEmpty[i] == "zip")
                {
                        var re1=/^\d{5}$/;
                        var re2=/^\d{9}$/;

                        if (val != "")
                        {
                                if (!((val.match(re1)) || (val.match(re2))))
                                {
                                        msgs.push("Incorrect Data Format for " + nonEmpty[i] + ".");
                                }
                        }
                }
        }
        if (msgs.length)
        {
                alert(msgs.join("\n"));
                return false;

        }
        return true;
}


