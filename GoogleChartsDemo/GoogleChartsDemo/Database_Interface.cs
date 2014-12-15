using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;




//database
using System.Data;
using System.Collections;

//generate Sqlite commands
using System.Data.SqlClient;
using System.Data.SQLite;

//thread_save_execute
using System.Runtime.InteropServices;
using System.Threading;

namespace GoogleChartsDemo
{

  public class Pair<T, U>
    {

        public Pair()
        {
        }

        public Pair(T first, U second)
        {
            this.First = first;
            this.Second = second;
        }

        public T First { get; set; }

        public U Second { get; set; }
    };


    public class DB_Interface
    {

        private string virtualPath = AppDomain.CurrentDomain.BaseDirectory;
        private string relative_db_path = "App_Data\\PatientsDB.sqlite"; 
        private int timeout = 30;
        
        SQLiteConnection con;

        public string error;

    
        public void db_commands(string cmd) //, ref string error
        {

            con = new SQLiteConnection("Data Source=" + virtualPath + relative_db_path + ";providerName=System.Data.SQLite");
            SQLiteCommand sqlite_cmd = new SQLiteCommand(con);
            sqlite_cmd.CommandText = cmd;

            con.Open();
            try
            {
                SQLiteTransaction transaction = con.BeginTransaction();

                sqlite_cmd.ExecuteNonQuery();

                transaction.Commit();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                con.Dispose();
            }

        }

        public void db_commands(string cmd, ref DataTable dt) //, ref string error
        {

            con = new SQLiteConnection("Data Source=" + virtualPath + relative_db_path + ";providerName=System.Data.SQLite");
            SQLiteCommand sqlite_cmd = new SQLiteCommand(con);
            sqlite_cmd.CommandText = cmd;

            con.Open();
            try
            {
                //this line may thorw "database is locked" exception
                SQLiteTransaction transaction = con.BeginTransaction();

                SQLiteDataReader reader = sqlite_cmd.ExecuteReader();
                dt.Load(reader);
                reader.Close();

                transaction.Commit();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                con.Dispose();
                sqlite_cmd.Dispose();
            }
          
        }

    }
}