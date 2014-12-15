<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="GoogleChartsDemo.test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> Hospital Data Visualization </title>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
 
    <script type="text/javascript" >

    google.load('visualization', '1.0', {'packages':['corechart', "timeline"]});

    google.setOnLoadCallback(drawChart);

    function drawChart() {
        drawSexPieChart();
    }
      
    function drawSexPieChart() {

        var data = new google.visualization.DataTable();

        var sexDistributionMale = <%=sex_distribution[0]%>;
        var sexDistributionFemale = <%=sex_distribution[1]%>;

        data.addColumn('string', 'Sex');
        data.addColumn('number', 'Count');
        data.addRows([
            ['Male', sexDistributionMale],
            ['Female', sexDistributionFemale]
        ]);

        var options = {'title':'Sex Distribution of Patients',
                       'width':300,
                       'height':300
                      };
 
        var sexPieChart = new google.visualization.PieChart(document.getElementById('sexPieChart_div'));

        function selectHandler() {
            var selectedItem = sexPieChart.getSelection()[0];
            if (selectedItem) {
		 
            var sex = data.getValue(selectedItem.row, 0);
            //alert('The user selected ' + sex);  
            drawTimeLineBarChart(sex);
            }
        }

        google.visualization.events.addListener(sexPieChart, 'select', selectHandler);    
        sexPieChart.draw(data, options);
    }


    function getPatientsBySex(sex) {
        var rst;
        $.ajax({
            type: "post",
            url: "test.aspx/getPatientsBySex",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: '{"sex":"' + sex + '"}',
            async: false,
            
            success: function (result) {
                rst = JSON.parse(result.d);
                //alert(" good " + rst);
            },
            error: function () {
                alert(" get Patients ajax call error ");
            }
        });
        return rst;
    }
    
    function drawTimeLineBarChart(sex) {

            //alert("passing sex:" + sex);
            //PageMethods.ajaxUpdate(sex);
            var patient_data = getPatientsBySex(sex);
            //alert("patient: "+patient_data);

            var container = document.getElementById('timeLineBarChart_div');
            var timeLineBarChart = new google.visualization.Timeline(container);
            var dataTable = new google.visualization.DataTable();
            
            dataTable.addColumn({ type: 'string', id: 'Period' });
            dataTable.addColumn({ type: 'string', id: 'HospitalizationID' });
            dataTable.addColumn({ type: 'date', id: 'Start' });
            dataTable.addColumn({ type: 'date', id: 'End' });
            
            var count = patient_data.length/7;

            for (i=0;i<count;i++){
                var delta = i*7;
                var startDate = new Date(patient_data[delta+1], patient_data[delta+2], patient_data[delta+3]);
                var endDate = new Date(patient_data[delta+4], patient_data[delta+5], patient_data[delta+6]);
                dataTable.addRows( [["Period", patient_data[delta+0], startDate, endDate]]); 
            }

            var options = {
                timeline: { showRowLabels: false }
            };
  		
            function selectHandler() {
                var selectedItem = timeLineBarChart.getSelection()[0];
                var HospitalizationID = dataTable.getValue(selectedItem.row, 1);
                //alert("HospitalizationID: " + HospitalizationID);
                if (selectedItem) {
                    drawLineChart(HospitalizationID);
                }
            }

            google.visualization.events.addListener(timeLineBarChart, 'select', selectHandler);    
            timeLineBarChart.draw(dataTable, options);
        }

        function getBarthelsByHospID(HospitalizationID) {
            var rst;
            $.ajax({
                type: "post",
                url: "test.aspx/getBarthelsByHospID",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{"HospitalizationID":"' + HospitalizationID + '"}',
                async: false,
            
                success: function (result) {
                    rst = JSON.parse(result.d);
                    //alert(" good " + rst);
                },
                error: function () {
                    alert(" get Barthels ajax call error ");
                }
            });
            return rst;
        }

        function Comparator(a,b){
            if (a[0] < b[0]) return -1;
            if (a[0] > b[0]) return 1;
            return 0;
        }

        function drawLineChart(HospitalizationID) {
            var barthelsData = getBarthelsByHospID(HospitalizationID);
            var dataLineArray = [];
            for (i=0; i<barthelsData.length/3; i++){
                var delta = i*3;
                dataLineArray[i] = [parseInt(barthelsData[delta],10), parseInt(barthelsData[delta+1],10)];
            }
            dataLineArray.sort(Comparator);

            var dataLine = new google.visualization.DataTable();
            dataLine.addColumn('number', 'Day');
            dataLine.addColumn('number', 'Total');
            dataLine.addRows(dataLineArray);

            var LineChart = new google.visualization.LineChart(document.getElementById('drawTrendLineBarChart_div'));

	        var options = {
	            title: 'Comparative Analysis',
	            hAxis: {title: 'Day'},
	            vAxis: {title: 'Total'},
	            //legend: 'none',
	            pointSize: 8
	        };

	        function selectHandler() {
	            var selectedItem = LineChart.getSelection()[0];
	            if (selectedItem) {
	                var DayID = dataLine.getValue(selectedItem.row, 0);
	                //alert("you selected dayID: " + DayID) ;
	                var BarthelID;
                    // Search barthelID by dayID from the data. Each barthelID is uniquely decided by a dayID. 
	                for (j=0; j<barthelsData.length/3; j++){
	                    var delta = j*3;
	                    if(DayID == parseInt(barthelsData[delta],10)) {
	                        BarthelID = parseInt(barthelsData[delta+2],10);
	                        break;
	                    }
	                }
	                alert("you selected BarthelID: " + BarthelID) ;
	            }
	        }
	        google.visualization.events.addListener(LineChart, 'select', selectHandler);   
	        LineChart.draw(dataLine, options);
        }
    </script>

</head>


<body>
    <form id="form1" runat="server">
    <div id="sexPieChart_div"></div>
    <div id="timeLineBarChart_div" style="height: 320px;"></div>
    <div id="drawTrendLineBarChart_div" style="width: 900px; height: 500px;"></div>
    </form>
</body>
</html>
