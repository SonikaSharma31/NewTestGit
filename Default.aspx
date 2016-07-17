<%@ Page Title="" Language="C#" MasterPageFile="~/MySite.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BSPC.QuoteApplication.Web.Default" ClientIDMode="Static" %>

<%@ MasterType VirtualPath="~/MySite.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="customScripts" runat="server">
    <script type="text/javascript">
        $(function ()

        {
            Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) {

                $('.typeahead').typeahead({
                    name: 'suburb-centre',
                    limit: 10,
                    prefetch: './Services/suburb-centre.json',
                    remote: {
                        url: './Services/GetSuburbCentre.aspx?q=%QUERY'
                    }
                }).on('typeahead:selected', function (obj, datum, name) {
                    if ($(this).prop('id') === 'txtSuburbFrom') {
                        var subHub = datum.value.split('_', 2);

                        $(this).typeahead('setQuery', subHub[0]);
                        $('#<%= txtHubFrom.ClientID %>').val(subHub[1]);
                        $('#<%= txtSuburbTo.ClientID %>').focus();
                    }
                    else {
                        var subHub = datum.value.split('_', 2);

                        $(this).typeahead('setQuery', subHub[0]);
                        $('#<%= txtHubTo.ClientID %>').val(subHub[1]);
                        $('#<%= txtUserAdjustment.ClientID %>').focus();
                    }
                });
            }
            );
		});
	</script>
   
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <form id="form1" runat="server" class="form-horizontal">

        <!-- Modal Add Suburb -->
				<div class="modal fade" id="modalAddATown" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" >
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								<h3 class="modal-title" id="modalAddATownTitle">Add a Town</h3>
							</div>
							<div class="modal-body">
								<div class="form-group">
									<asp:Label ID="lblAddHub" AssociatedControlID="ddlAddHub" runat="server" Text="Hub:" CssClass="col-sm-4 control-label" />
									<div class="col-sm-8">
										<asp:DropDownList ID="ddlAddHub" name="ddlAddHub" runat="server" CssClass="form-control selectpicker show-menu-arrow">
											<asp:ListItem></asp:ListItem>
										</asp:DropDownList>
									</div>
								</div>
								<div class="form-group">
									<label for="suburb" class="col-sm-4 control-label">Suburb:</label>
									<div class="col-sm-8">
										<div class="input-group">
											<span class="input-group-addon">
												<span class="glyphicon glyphicon-home"></span>
											</span>
                                             <asp:TextBox ID="TextBoxSub" runat="server" CssClass="form-control" />
											<%--<input type="text" class="form-control" id="suburb">--%>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label for="state" class="col-sm-4 control-label">State:</label>
									<div class="col-sm-8">
										<div class="input-group">
											<span class="input-group-addon">
												<span class="glyphicon glyphicon-screenshot"></span>
											</span>
                                             <asp:TextBox ID="TextBoxS" runat="server" CssClass="form-control" />
											<%--<input type="text" class="form-control" id="state">--%>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label for="postcode" class="col-sm-4 control-label">Postcode:</label>
									<div class="col-sm-8">
										<div class="input-group">
											<span class="input-group-addon">
												<span class="glyphicon glyphicon-envelope"></span>
											</span>
                                             <asp:TextBox ID="TextBoxPC" runat="server" CssClass="form-control" />
											<%--<input type="text" class="form-control" id="postcode">--%>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label for="distance" class="col-sm-4 control-label">Distance from Hub:</label>
									<div class="col-sm-8">
										<div class="input-group">
											<span class="input-group-addon">
												<span class="glyphicon glyphicon-resize-full"></span>
											</span>
                                             <asp:TextBox ID="TextBoxKm" runat="server" CssClass="form-control" />
											<%--<input type="text" class="form-control" id="distance">--%>
											<span class="input-group-addon">km</span>
										</div>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                 <asp:Button ID="ButtonSave" runat="server" Text="Save Changes" cssclass="btn btn-primary" OnClick="ButtonSave_Click" />
								<%--<button type="button" class="btn btn-primary">Save Changes</button>--%>
							</div>
						</div>
					</div>
				</div>
				<!-- End of Modal Add Suburb -->

        <asp:ScriptManager ID="bspc" runat="server" ></asp:ScriptManager>
        
        <asp:UpdatePanel ID="uptest" runat="server" >
            <ContentTemplate>

    <div class="row">
		
			<div class="col-md-4">
				<h2>Calculate Quote</h2>
				<hr />

				<!-- Suburb From Field -->
				<div class="form-group">
					<asp:Label ID="lblSuburbFrom" AssociatedControlID="txtSuburbFrom" runat="server" Text="Suburb From:" CssClass="col-sm-2 col-md-4 control-label" />
					<div class="col-sm-10 col-md-8">
						<div class="input-group">
							<span class="input-group-btn">
								<button class="btn btn-default" type="button" data-toggle="modal" data-target="#modalAddATown">
									<span class="glyphicon glyphicon-plus-sign"></span>
								</button>
							</span>
							<asp:TextBox ID="txtSuburbFrom" runat="server" CssClass="typeahead form-control" />
						</div>
					</div>
				</div>

				<!-- Hub From Field -->
				<div class="form-group">
					<asp:Label ID="lblHubFrom" AssociatedControlID="txtHubFrom" runat="server" Text="Hub From:" CssClass="col-sm-2 col-md-4 control-label" />
					<div class="col-sm-10 col-md-8">
						<asp:TextBox ID="txtHubFrom" runat="server" CssClass="form-control" />
						<input type="text" name="valHubFrom" id="valHubFrom" hidden="hidden" />
					</div>
				</div>

				<!-- Suburb To Field -->
				<div class="form-group">
					<asp:Label ID="lblSuburbTo" AssociatedControlID="txtSuburbTo" runat="server" Text="Suburb To:" CssClass="col-sm-2 col-md-4 control-label" />
					<div class="col-sm-10 col-md-8">
						<div class="input-group">
							<span class="input-group-btn">
								<button class="btn btn-default" type="button" data-toggle="modal" data-target="#modalAddATown">
									<span class="glyphicon glyphicon-plus-sign"></span>
								</button>
							</span>
							<asp:TextBox ID="txtSuburbTo" runat="server" CssClass="typeahead form-control" />
                        </div>
					</div>
				</div>

				<!-- Hub To Field -->
				<div class="form-group">
					<asp:Label ID="lblHubTo" AssociatedControlID="txtHubTo" runat="server" Text="Hub To:" CssClass="col-sm-2 col-md-4 control-label" />
					<div class="col-sm-10 col-md-8">
						<asp:TextBox ID="txtHubTo" runat="server" CssClass="form-control" />
						<input type="text" name="valHubTo" id="valHubTo" hidden="hidden" />
					</div>
				</div>

				<!-- User Adjustment Field -->
				<div class="form-group">
					<asp:Label ID="lblUserAdjustment" AssociatedControlID="txtUserAdjustment" runat="server" Text="User Adjustment:" CssClass="col-sm-2 col-md-4 control-label" />
					<div class="col-sm-10 col-md-8">
						<asp:TextBox ID="txtUserAdjustment" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="User notes" Rows="3" />
					</div>
					<div class="col-sm-2 col-md-4">
					</div>
					<div class="col-sm-10 col-md-8">
						<div class="input-group">
							<span class="input-group-addon">$</span>
							<asp:TextBox ID="txtUserPrice" runat="server" CssClass="form-control" />
						</div>
					</div>
				</div>

				<!-- Calculate For Which Feet -->
				<div class="form-group">
					<label class="col-sm-2 col-md-4 control-label">Calculate for:</label>
					<div class="col-sm-10 col-md-8">
						<div class="radio">
							<label>

								<input type="radio" name="gridRadios" id="gridRadios1" value="20 ft" checked>
								20 Feet
							</label>
						&nbsp;&nbsp;</div>
						<div class="radio">
							<label>
								<input type="radio" name="gridRadios" id="gridRadios2" value="40 ft">
								40 Feet
							</label>
						&nbsp;&nbsp;</div>
					</div>
				</div>

				<hr />

				<!-- Buttons Section Field -->
				<div class="form-group">
					<div class="col-sm-2 col-md-4">
                        <asp:Button ID="ButtonM" runat="server" Text="Margin Rules" CssClass="btn btn-default pull-right" OnClick="ButtonM_Click" TabIndex="-1" />
						<%--<input type="submit" class="btn btn-default pull-right" value="Margin Rules" />--%>
					</div>
					<div class="col-sm-10 col-md-8">
						<button type="button" id="btnCalculate" class="btn btn-primary pull-right calculate">Calculate Quote</button>
					</div>
				</div>

				<hr />

				<!-- Post Code Field -->
				<div class="form-group">
					<asp:Label ID="lblPostCode" AssociatedControlID="txtPostCode" runat="server" Text="Post Code:" CssClass="col-sm-2 col-md-4 control-label" />
					<div class="col-sm-10 col-md-8">
						<asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control" />
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-10 col-sm-offset-2 col-md-8 col-md-offset-4">
                        <asp:Button ID="ButtonPS" runat="server" Text="Search" CssClass="btn btn-default pull-right" OnClick="ButtonPSearch_Click"/>
						<%--<input type="submit" class="btn btn-default pull-right" value="Search" />--%>
					</div>
				</div>
			</div>

			<!-- Quote Result -->
			<div id="result" class="col-md-4" runat="server">
				<h2>Quote Result</h2>
				<hr />
				<div id="quoteResultData"></div>    
				<%--<button id="btnSaveQuote" type="button" class="btn btn-primary pull-right save" >Save Quote</button>   --%>
                <asp:Button ID="ButtonSQ" runat="server" CssClass="btn btn-primary pull-right" Text="Save Quote" OnClick="QuoteSave" />
      		</div>
			<!-- End of Quote Result -->
		
	</div>
        <div id="grids" class="row">

        <div class="col-md-6">
            <asp:GridView ID="GridView1" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None" AllowPaging="True"  DataKeyNames="DistanceId" AutoGenerateColumns="False" OnPageIndexChanging="OnPagingGv1" OnRowEditing="EditDistGv1" OnRowCancelingEdit="CancelEditGv1" OnRowUpdating="UpdateDistGv1">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                        <asp:TemplateField ItemStyle-Width = "100px"  HeaderText = "Centre">
                            <ItemTemplate>
                                     <asp:Label ID="lblHub" runat="server"
                                          Text='<%# Eval("Centre")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                     <asp:TextBox ID="txtHub" runat="server"
                                           Text='<%# Eval("Centre")%>'></asp:TextBox>
                            </EditItemTemplate> 
                            <FooterTemplate>
                                      <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                            </FooterTemplate>

                            <ItemStyle Width="100px"></ItemStyle>
                       </asp:TemplateField>
                       <asp:TemplateField ItemStyle-Width = "150px"  HeaderText = "Suburb">
                            <ItemTemplate>
                                         <asp:Label ID="lblSub" runat="server"
                                             Text='<%# Eval("Suburb")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                        <asp:TextBox ID="txtSub" runat="server"
                                                 Text='<%# Eval("Suburb")%>'></asp:TextBox>
                            </EditItemTemplate> 
                            <FooterTemplate>
                                         <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                            </FooterTemplate>

                            <ItemStyle Width="150px"></ItemStyle>
                      </asp:TemplateField>
                     <asp:TemplateField ItemStyle-Width = "150px"  HeaderText = "State">
                           <ItemTemplate>
                                 <asp:Label ID="lblS" runat="server"
                                      Text='<%# Eval("State")%>'></asp:Label>
                           </ItemTemplate>
                           <EditItemTemplate>
                                    <asp:TextBox ID="txtS" runat="server"
                                         Text='<%# Eval("State")%>'></asp:TextBox>
                           </EditItemTemplate> 
                           <FooterTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server"></asp:TextBox>
                           </FooterTemplate>

<ItemStyle Width="150px"></ItemStyle>
                                    </asp:TemplateField>
                      <asp:TemplateField ItemStyle-Width = "100px"  HeaderText = "Distance">
                           <ItemTemplate>
                                <asp:Label ID="lblKm" runat="server"
                                     Text='<%# Eval("Kilometres")%>'></asp:Label>
                           </ItemTemplate>
                           <EditItemTemplate>
                                <asp:TextBox ID="txtKm" runat="server"
                                      Text='<%# Eval("Kilometres")%>'></asp:TextBox>
                           </EditItemTemplate> 
                           <FooterTemplate>
                                <asp:TextBox ID="TextBox4" runat="server"></asp:TextBox>
                           </FooterTemplate>

                            <ItemStyle Width="100px"></ItemStyle>
                       </asp:TemplateField>
                       <asp:CommandField ShowEditButton="True" CausesValidation="False" />
                        </Columns>
                                    <EditRowStyle BackColor="#2461BF" />
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#EFF3FB" />
                                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                    <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                    <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                    <SortedDescendingHeaderStyle BackColor="#4870BE" />
                </asp:GridView>
        </div>
            </div>
        <div class="row">
             <div class="col-md-6">
                <asp:GridView ID="GridView2" runat="server"  Width = "550px" AutoGenerateColumns = "False" OnPageIndexChanging="OnPaging" OnRowEditing="EditMargin" OnRowCancelingEdit="CancelEdit" OnRowUpdating="UpdateMargin" OnRowDeleting="DeleteMargin" Font-Names = "Arial" Font-Size = "11pt" AlternatingRowStyle-BackColor = "#C2D69B" 
                              HeaderStyle-BackColor = "green" AllowPaging ="True"  ShowFooter = "True" CellPadding="4" ForeColor="#333333" GridLines="None" DataKeyNames="MId" CssClass="auto-style101" >
                     <AlternatingRowStyle BackColor="White"></AlternatingRowStyle>
                     <Columns>
                            <asp:TemplateField ItemStyle-Width = "100px"  HeaderText = "Hub From">
                                <ItemTemplate>
                                        <asp:Label ID="lblHF" runat="server"
                                          Text='<%# Eval("HubFrom")%>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                        <asp:TextBox ID="txtHF" runat="server"
                                         Text='<%# Eval("HubFrom")%>'></asp:TextBox>
                                </EditItemTemplate> 
                                <FooterTemplate>
                                <asp:TextBox ID="txtHF1" runat="server" BackColor="White" ForeColor="Black"></asp:TextBox>
                                </FooterTemplate>

                                <ItemStyle Width="100px"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width = "150px"  HeaderText = "Hub To">
                                <ItemTemplate>
                                        <asp:Label ID="lblHT" runat="server"
                                             Text='<%# Eval("HubTo")%>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtHT" runat="server"
                                        Text='<%# Eval("HubTo")%>'></asp:TextBox>
                                </EditItemTemplate> 
                                <FooterTemplate>
                                    <asp:TextBox ID="txtHT1" runat="server" BackColor="White" ForeColor="Black"></asp:TextBox>
                                </FooterTemplate>

                                <ItemStyle Width="150px"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width = "150px"  HeaderText = "Margin">
                                <ItemTemplate>
                                    <asp:Label ID="lblM" runat="server"
                                         Text='<%# Eval("Margin")%>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtM" runat="server"
                                         Text='<%# Eval("Margin")%>'></asp:TextBox>
                                </EditItemTemplate> 
                                <FooterTemplate>
                                    <asp:TextBox ID="txtM1" runat="server" BackColor="White" ForeColor="Black"></asp:TextBox>
                                </FooterTemplate>

                                <ItemStyle Width="150px"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                     <asp:LinkButton ID="lnkRemove" runat="server" OnClientClick = "return confirm('Do you want to delete?')"
                                                     Text = "Delete"  CommandName="Delete" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-default" OnClick="AddNewMargin" CausesValidation="False" Height="27" Width="50" Font-Size="Small" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <%--<asp:CommandField ShowdeleteButton="true" />--%>
                            <asp:CommandField  ShowEditButton="True" CausesValidation="False" />
                                </Columns>
                                            <EditRowStyle BackColor="#2461BF" />
                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"></HeaderStyle>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                            <RowStyle BackColor="#EFF3FB" />
                                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                            <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                            <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                            <SortedDescendingHeaderStyle BackColor="#4870BE" />
                    </asp:GridView>
        </div>
            </div>
        <asp:HiddenField ID="hdnsubfrom" runat="server"  />
        <asp:HiddenField ID="hdnhubfrom" runat="server"  />
        <asp:HiddenField ID="hdnsubto" runat="server"  />
        <asp:HiddenField ID="hdnhubto" runat="server"  />
        <asp:HiddenField ID="hdnrate" runat="server"  />
        <asp:HiddenField ID="hdntrucko" runat="server"  />
        <asp:HiddenField ID="hdnrail" runat="server"  />
        <asp:HiddenField ID="hdntruckd" runat="server"  />
        <asp:HiddenField ID="hdnmargin" runat="server"  />
        <asp:HiddenField ID="hdnmarginadj" runat="server"  />
        <asp:HiddenField ID="hdnuseradj" runat="server"  />
        <asp:HiddenField ID="hdnuserprice" runat="server"  />
        <asp:HiddenField ID="hdngst" runat="server"  />
        <asp:HiddenField ID="hdntotal" runat="server"  />

        <asp:HiddenField ID="hdradiocheck" runat="server"  />
        <asp:HiddenField ID="hdgrid" runat="server" />

        <!-- Quote Result Template -->
	<script id="quoteResultTemplate" type="text/x-jsrender">
		<div class="well">
			<p>A {{:Feet}} container moving from {{:SuburbFrom}}, {{:StateFrom}} via {{:HubFrom}}, {{:DistanceFrom}}km. to {{:SuburbTo}}, {{:StateTo}} via {{:HubTo}}, {{:DistanceTo}}km.</p>
		</div>
		<div class="list-group" runat="server">
			<a class="list-group-item"><span class="pull-right">{{:Rate}}</span>Container Hire</a>
			<a class="list-group-item"><span class="pull-right">{{:TrucksOrigin}}</span>Trucks - Origin</a>
			<a class="list-group-item"><span class="pull-right">{{:Rail}}</span>Rail</a>
			<a class="list-group-item"><span class="pull-right">{{:TrucksDestination}}</span>Trucks - Destination</a>
			<a class="list-group-item"><span class="pull-right">{{:Margin}}</span>Margin</a>
			<a class="list-group-item"><span class="pull-right">{{:MarginAdjustments}}</span>Margin Adjustments</a>
			{{if UserAdjustment}}
			<a class="list-group-item"><span class="pull-right">{{:UserPrice}}</span>{{:UserAdjustment}}</a>
			{{/if}}
			<a class="list-group-item"><span class="pull-right">{{:Gst}}</span>GST</a>
			<a class="list-group-item active"><span class="pull-right">{{:Total}}</span>Quote Total</a>
		</div>
	</script>

            </ContentTemplate>

        </asp:UpdatePanel>
        </form>
 
	
	<script type="text/javascript">
	    $(function () {
	        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) {

	            if ($("#hdgrid").val() == "") {
	                $('#txtSuburbFrom').focus();
	            };
	            $('#result').hide();

	            if ($("#hdradiocheck").val() != "") {
	                $("#gridRadios2").prop("checked", "checked");
	                $("#gridRadios1").removeProp("checked");
	            }

	            if($("#txtSuburbFrom").val()!="")
	            {
	                calculate();
	            }
	          
	            $('.calculate').click(calculate);
               
	        });
	    });

	    function calculate() {

	        $('#hdradiocheck').val("");
	        if ($("#gridRadios2").prop("checked"))
	        {
	            $("#hdradiocheck").val("40");
	        }
	        
			$('#valHubFrom').val($('#<%= txtHubFrom.ClientID %>').val());
			$('#valHubTo').val($('#<%= txtHubTo.ClientID %>').val());

		    var formData = $('form').serializeArray();
		    if ($("#txtSuburbFrom").val() == "") {
		        alert('Error: Suburb from field is required.');
		        return false;
		    }
		    if ($("#txtSuburbTo").val() == "") {
		        alert('Error: Suburb To field is required.')
		        return false;
		    }
			if ($("#txtUserPrice").val() != "") {
			    if ($("#txtUserAdjustment").val() == "") {
			        alert('Error: Please enter useradjustment note.');
			        return false;
			    }
			}
			$.ajax({
				type: 'POST',
				url: './Services/Calculate.aspx',
				data: formData,
				dataType: 'json'
			}).done(function (quoteResultData) {
			    $('#quoteResultData').html(
					$('#quoteResultTemplate').render(quoteResultData)
				);

			    $("#hdnsubfrom").val(quoteResultData.SuburbFrom);
			    $("#hdnhubfrom").val(quoteResultData.HubFrom);
			    $("#hdnsubto").val(quoteResultData.SuburbTo);
			    $("#hdnhubto").val(quoteResultData.HubTo);
			    $("#hdnrate").val(quoteResultData.Rate);
			    $("#hdntrucko").val(quoteResultData.TrucksOrigin);
			    $("#hdnrail").val(quoteResultData.Rail);
			    $("#hdntruckd").val(quoteResultData.TrucksDestination);
			    $("#hdnmargin").val(quoteResultData.Margin);
			    $("#hdnmarginadj").val(quoteResultData.MarginAdjustments);
			    $("#hdnuseradj").val(quoteResultData.UserAdjustment);
			    $("#hdnuserprice").val(quoteResultData.UserPrice);
			    $("#hdngst").val(quoteResultData.Gst);
			    $("#hdntotal").val(quoteResultData.Total);
				$('#result').show('slide');
			}).fail(function () {
				alert('Error: Call to calculate failed.');
			});
	    }

	</script>
</asp:Content>
