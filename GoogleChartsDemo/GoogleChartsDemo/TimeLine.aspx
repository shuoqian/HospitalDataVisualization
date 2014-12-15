<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeLine.aspx.cs" Inherits="GoogleChartsDemo.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["timeline"] });
        google.setOnLoadCallback(drawChart);

        function drawChart() { debugger;
            var container = document.getElementById('timeline');
            var chart = new google.visualization.Timeline(container);
            var dataTable = new google.visualization.DataTable();

            dataTable.addColumn({ type: 'string', id: 'Position' });
            dataTable.addColumn({ type: 'string', id: 'President' });
            dataTable.addColumn({ type: 'date', id: 'Start' });
            dataTable.addColumn({ type: 'date', id: 'End' });

            var patient_data = <%= rst %>;
            alert("patient: "+patient_data);
            
            var count = patient_data.length/7;
            for (i=0;i<count;i++)
            {
                var delta = i*7;
                dataTable.addRows( [[patient_data[delta+0], patient_data[delta+0], 
                    new Date(patient_data[delta+1], patient_data[delta+2], patient_data[delta+3]), 
                    new Date(patient_data[delta+4], patient_data[delta+5], patient_data[delta+6])]]);
            }
            
            //    dataTable.addRows( [['1', 'Washington', new Date(2014, 5, 9), new Date(2014, 5, 12)]]);

            //dataTable.addRows([
             
            //  ['1', 'Adams', new Date(2014, 5, 20), new Date(2014, 6, 3)],
            //  ['1', 'Jefferson', new Date(2014, 6, 10), new Date(2014, 6, 15)],
            //  ['2', 'Jefferson', new Date(2014, 5, 10), new Date(2014, 5, 15)],
            //  ['2', 'Jefferson', new Date(2014, 5, 16), new Date(2014, 5, 19)]
            //]);

            chart.draw(dataTable);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <div id="timeline" style="width: 900px; height: 980px;"></div>
    </div>
    </form>
</body>
</html>
