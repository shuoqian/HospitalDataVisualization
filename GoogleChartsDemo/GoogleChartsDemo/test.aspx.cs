using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Script.Serialization;

//database
using System.Data;
using System.Collections;

namespace GoogleChartsDemo
{
    public partial class test : System.Web.UI.Page
    {
        public int[] sex_distribution; // 0 - male | 1 - female
        public static DB_Interface db = new DB_Interface();
        public static JavaScriptSerializer serializer = new JavaScriptSerializer();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DataTable dt = new DataTable();
                sex_distribution = new int[2];
                // count male patients 
                db.db_commands("SELECT count(*) FROM Patients WHERE Patients.Sex = 'M'", ref dt);
                sex_distribution[0] = Int32.Parse(dt.Rows[0][0].ToString());
                
                // count female patients
                db.db_commands("SELECT count(*) FROM Patients WHERE Patients.Sex = 'F'", ref dt);
                sex_distribution[1] = Int32.Parse(dt.Rows[1][0].ToString());
   
            }
        }

        [System.Web.Services.WebMethod]
        public static string getPatientsBySex(string sex)
        {
            DataTable HospDt = new DataTable();
            string sexSQL = sex.Equals("Female")? "F":"M";
            string cmd = "select * from Patients join Hospitalization where Patients.PatientID=Hospitalization.PatientID and Patients.Sex='"+sexSQL+"';";
            db.db_commands(cmd, ref HospDt);

            string[,] patient_data = new string[HospDt.Rows.Count, 7];
            for (int i = 0; i < HospDt.Rows.Count; i++)
            {
                patient_data[i, 0] = HospDt.Rows[i]["HospitalizationID"].ToString();
                string[] start_date = HospDt.Rows[i]["AdmissionDate"].ToString().Split('-');
                string[] end_date = HospDt.Rows[i]["DischargeDate"].ToString().Split('-');

                patient_data[i, 1] = start_date[0];
                patient_data[i, 2] = start_date[1];
                patient_data[i, 3] = start_date[2];

                patient_data[i, 4] = end_date[0];
                patient_data[i, 5] = end_date[1];
                patient_data[i, 6] = end_date[2];
            }
            return serializer.Serialize(patient_data);     
        }

        [System.Web.Services.WebMethod]
        public static string getBarthelsByHospID(string HospitalizationID)
        {
            DataTable BarthelDt = new DataTable();
            string cmd = "select * from Barthels where HospitalizationID='" + HospitalizationID + "';";
            db.db_commands(cmd, ref BarthelDt);

            string[,] barthel_data = new string[BarthelDt.Rows.Count, 3];
            for (int i = 0; i < BarthelDt.Rows.Count; i++)
            {
                barthel_data[i, 0] = BarthelDt.Rows[i]["Day"].ToString();
                barthel_data[i, 1] = BarthelDt.Rows[i]["Total"].ToString();
                barthel_data[i, 2] = BarthelDt.Rows[i]["BarthelID"].ToString();
            }
            return serializer.Serialize(barthel_data);
        }

    }
}