using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

//database
using System.Data;
using System.Collections;


namespace GoogleChartsDemo
{
    public partial class Default : System.Web.UI.Page
    {
        public string rst;
        public string[,] patient_data;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DB_Interface db = new DB_Interface();
                DataTable dt = new DataTable();

                /*and sex='?'*/
                db.db_commands("select * from Patients join Hospitalization where Patients.PatientID=Hospitalization.PatientID and Patients.PatientID<40;", ref dt);

                patient_data = new string[dt.Rows.Count, 7];
                
                for (int i = 0; i < dt.Rows.Count;i++ )
                {
                    patient_data[i, 0] = dt.Rows[i]["HospitalizationID"].ToString();
                    string[] start_date = dt.Rows[i]["AdmissionDate"].ToString().Split('-');
                    string[] end_date = dt.Rows[i]["DischargeDate"].ToString().Split('-');

                    patient_data[i, 1] = start_date[0];
                    patient_data[i, 2] = start_date[1];
                    patient_data[i, 3] = start_date[2];

                    patient_data[i, 4] = end_date[0];
                    patient_data[i, 5] = end_date[1];
                    patient_data[i, 6] = end_date[2];
                }

                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                rst = serializer.Serialize(patient_data);
            }
        }
    }
}