using BSPC.QuoteApplication.Web.Data;
using BSPC.QuoteApplication.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using BSPC.QuoteApplication.Web.Helper;
using BSPC.QuoteApplication.Web;

namespace BSPC.QuoteApplication.Web
{
	public partial class Default : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				GetLoggedOnUser();

				InitializeHubDropDownLists();
			}
        }

		private void InitializeHubDropDownLists()
		{
			ddlAddHub.Items.Clear();
			ddlAddHub.Items.Add(new ListItem());

			foreach (var hub in HubAdapter.GetHubs())
			{
				var item = new ListItem();

				item.Text = hub.Centre;
				item.Value = hub.HubId.ToString();
				item.Attributes.Add("data-subtext", hub.State);
				ddlAddHub.Items.Add(item);
            }
		}

		private void GetLoggedOnUser()
		{
			var logOnName = WindowsIdentity.GetCurrent().Name;

			if (!PersonAdapter.UserExists(logOnName))
			{
				var person = new Person()
				{
					LogOnName = logOnName,
					DisplayName = logOnName
				};

				PersonAdapter.Add(person);
			}

			Master.User = logOnName;
		}

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Guid hubid = Guid.Parse(ddlAddHub.SelectedValue);
            string sub = TextBoxSub.Text;
            string state = TextBoxS.Text;
            string PC = TextBoxPC.Text;
            string KM = TextBoxKm.Text;
            var statekilometres = new StateKilometres()
            {
                HubId = hubid,
                Suburb = sub,
                Postcode = PC,
                State = state,
                Kilometres = KM
            };
            DistanceAdapter.AddTown(statekilometres);
        }

        protected void QuoteSave (object sender, EventArgs e)
        {
            string logOnName = WindowsIdentity.GetCurrent().Name;
            string hubfrom = hdnhubfrom.Value.ToString();
            string hubto = hdnhubto.Value.ToString();
            var quote = new Quote()
            {
                FromHubId = Guid.Parse(HubAdapter.GetHubId(hubfrom)),
                ToHubId = Guid.Parse(HubAdapter.GetHubId(hubto)),
                FromSuburb = hdnsubfrom.Value.ToString(),
                ToSuburb = hdnsubto.Value.ToString(),
                ContainerHire = Convert.ToDecimal(hdnrate.Value.ToString().Replace("$", "")),
                //ContainerHire = Convert.ToDecimal(Label1.Text.ToString().Replace("$", "")),
                TruckOrigin = Convert.ToDecimal(hdntrucko.Value.ToString().Replace("$", "")),
                Rail = Convert.ToDecimal(hdnrail.Value.ToString().Replace("$", "")),
                TruckDestination = Convert.ToDecimal(hdntruckd.Value.ToString().Replace("$", "")),
                Margin = Convert.ToDecimal(hdnmargin.Value.ToString().Replace("$", "")),
                MarginAdjustment = Convert.ToDecimal(hdnmarginadj.Value.ToString().Replace("$", "")),
                UserNotes = hdnuseradj.Value.ToString(),
                UserAdjustment = Convert.ToDecimal(hdnuserprice.Value.ToString().Replace("$", "")),
                Gst = Convert.ToDecimal(hdngst.Value.ToString().Replace("$", "")),
                Total = Convert.ToDecimal(hdntotal.Value.ToString().Replace("$", "")),
                PersonId = Guid.Parse(PersonAdapter.GetPersonId(Master.User))
            };
            QuoteAdapter.SaveQuote(quote);
        }

        protected void ButtonPSearch_Click (object sender, EventArgs e)
        {
            BindDataGv1();
        }
        private void BindDataGv1()
        {
            hdgrid.Value = "10";
            var PCode = txtPostCode.Text;
            using (var db = new DatabaseHelper())
            {
                using (var reader = db.ExecDataSet(Queries.BindGV1, "@PCode", PCode))
                {
                    GridView1.DataSource = reader;
                }
            }
                GridView1.DataBind();
        }
        protected void OnPagingGv1(object sender, GridViewPageEventArgs e)
        {
           
            GridView1.PageIndex = e.NewPageIndex;
            BindDataGv1();
        }
        protected void EditDistGv1(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            BindDataGv1();
        }
        protected void CancelEditGv1(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            BindDataGv1();
        }
        protected void UpdateDistGv1(object sender, GridViewUpdateEventArgs e)
        {
            string HubName = ((TextBox)GridView1.Rows[e.RowIndex].FindControl("txtHub")).Text;
            string SubName = ((TextBox)GridView1.Rows[e.RowIndex].FindControl("txtSub")).Text;
            string StateName = ((TextBox)GridView1.Rows[e.RowIndex].FindControl("txtS")).Text;
            string Km = ((TextBox)GridView1.Rows[e.RowIndex].FindControl("txtKm")).Text;
            var DistanceId = GridView1.DataKeys[e.RowIndex].Value;
            var PCode = txtPostCode.Text;
            using (var db = new DatabaseHelper())
            {
                db.ExecNonQuery(Queries.UpdateGV1, "@Sub", SubName, "@state", StateName, "@Km", Km, "@DId", DistanceId);
                GridView1.EditIndex = -1;
                //using (var reader = db.ExecDataSet(Queries.BindGV1, "@PCode", PCode)){GridView1.DataSource = reader;}GridView1.DataBind();
                BindDataGv1();
            }
        }

        protected void ButtonM_Click(object sender, EventArgs e)
        {
            BindData();
        }
        private void BindData()
        {
            hdgrid.Value = "10";
            using (var db = new DatabaseHelper())
            {
                using (var reader = db.ExecDataSet(Queries.BindGV2))
                {
                    GridView2.DataSource = reader;
                }
            }
            GridView2.DataBind();
        }
        protected void AddNewMargin(object sender, EventArgs e)
        {
            Guid NewGUID = Guid.NewGuid();
            string Hubf = ((TextBox)GridView2.FooterRow.FindControl("txtHF1")).Text;
            string Hubt = ((TextBox)GridView2.FooterRow.FindControl("txtHT1")).Text;
            float Mar = float.Parse(((TextBox)GridView2.FooterRow.FindControl("txtM1")).Text);
            //GridAdapter.AddMargin(NewGUID,Hubf,Hubt,Mar);
            using (var db = new DatabaseHelper())
            {
                db.ExecNonQuery(Queries.AddMargin, "@ID", NewGUID, "@HF", Hubf, "@HT", Hubt, "@M", Mar);
                GridView2.EditIndex = -1;
                BindData();
            }
        }
        protected void EditMargin(object sender, GridViewEditEventArgs e)
        {
            GridView2.EditIndex = e.NewEditIndex;
            BindData();
        }
        protected void CancelEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView2.EditIndex = -1;
            BindData();
        }
        protected void UpdateMargin(object sender, GridViewUpdateEventArgs e)
        {
            string Hubf = ((TextBox)GridView2.Rows[e.RowIndex].FindControl("txtHF")).Text;
            string Hubt = ((TextBox)GridView2.Rows[e.RowIndex].FindControl("txtHT")).Text;
            float Mar = float.Parse(((TextBox)GridView2.Rows[e.RowIndex].FindControl("txtM")).Text);
            var MId = GridView2.DataKeys[e.RowIndex].Value;
            using (var db = new DatabaseHelper())
            {
                db.ExecNonQuery(Queries.UpdateGV2, "@Hubf", Hubf, "@Hubt", Hubt, "@Mar", Mar, "@MId", MId);
                GridView2.EditIndex = -1;
                BindData();
            }
        }
        protected void DeleteMargin(object sender, GridViewDeleteEventArgs e)
        {
            var MId = GridView2.DataKeys[e.RowIndex].Value;
            using (var db = new DatabaseHelper())
            {
                db.ExecNonQuery(Queries.DeleteMargin, "@MId", MId);
                GridView2.EditIndex = -1;
                BindData();
            }
        }

        protected void OnPaging(object sender, GridViewPageEventArgs e)
        {
            GridView2.PageIndex = e.NewPageIndex;
            BindData();
        }

    }
}