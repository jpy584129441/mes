
	
	<script type="text/javascript">

		var substitutesColNames = new Array();
		var substitutesColModel = new Array();
		<c:forEach items="${substituteGridDefinition.columns}" var="column">
			substitutesColNames.push("<spring:message code="substitutes.column.${column.name}"/>");
			substitutesColModel.push({name:"${column.name}", index:"${column.name}", width:100, sortable: false});
		</c:forEach>
		var substitutesGrid;

		var substituteComponentsColNames = new Array();
		var substituteComponentsColModel = new Array();
		<c:forEach items="${substituteComponentGridDefinition.columns}" var="column">
			substituteComponentsColNames.push("<spring:message code="substitutes.column.${column.name}"/>");
			substituteComponentsColModel.push({name:"${column.name}", index:"${column.name}", width:100, sortable: false});
		</c:forEach>
		var substituteComponentsGrid;

		var editSubstituteWindow;
		var editSubstituteComponentWindow;
		
		jQuery(document).ready(function(){
			substitutesGrid = new QCDGrid({
				element: 'substitutesGrid',
				dataSource: "substitute/data.html?productId=${entityId }",
				deleteUrl: "substitute/deleteSubstitute.html",
				height: 150, 
				paging: false,
				colNames: substitutesColNames,
				colModel: substitutesColModel,
				loadingText: 'Wczytuje...',
				onSelectRow: function(id){
			        substituteComponentsGrid.setOption('dataSource','substitute/components.html?productId=${entityId }&substituteId='+id);
			        substituteComponentsGrid.refresh();
			        $("#newSubstituteComponentButton").attr("disabled", false);
			        $("#deleteSubstituteButton").attr("disabled", false);
			        $("#upSubstituteButton").attr("disabled", false);
			        $("#downSubstituteButton").attr("disabled", false);
		        },
				ondblClickRow: function(id){
		        	editSubstituteWindow = $('#editSubstituteWindow').jqm({ajax: 'substitute/editSubstitute.html?productId=${entityId }&substituteId='+id});
		        	editSubstituteWindow.jqmShow();
		        }
			});

			substituteComponentsGrid = new QCDGrid({
				element: 'substituteComponentsGrid',
				deleteUrl: "substitute/deleteSubstituteComponent.html",
				height: 150, 
				paging: false,
				colNames: substituteComponentsColNames,
				colModel: substituteComponentsColModel,
				loadingText: 'Wczytuje...',
				onSelectRow: function(id){
					$("#deleteSubstituteComponentButton").attr("disabled", false);
				},
				ondblClickRow: function(id){
					editSubstituteComponentWindow = $('#editSubstituteComponentWindow').jqm({
						ajax: 'substitute/editSubstituteComponent.html?substituteId='+substitutesGrid.getSelectedRow()+'&componentId='+id
					});
					editSubstituteComponentWindow.jqmShow();
				}
			});

			 $("#newSubstituteComponentButton").attr("disabled", true);
			 $("#deleteSubstituteComponentButton").attr("disabled", true);
			 $("#deleteSubstituteButton").attr("disabled", true);
			 $("#upSubstituteButton").attr("disabled", true);
			 $("#downSubstituteButton").attr("disabled", true);

			 if ("${entityId }") {
			 	substitutesGrid.refresh();
			 } else {
				 $("#newSubstituteButton").attr("disabled", true);
			 }

			 editSubstituteWindow = $('#editSubstituteWindow').jqm({modal: true});
			 editSubstituteComponentWindow = $('#editSubstituteComponentWindow').jqm({modal: true});
		});

		newSubstituteClicked = function() {
			editSubstituteWindow = $('#editSubstituteWindow').jqm({ajax: 'substitute/editSubstitute.html?productId=${entityId }'});
			editSubstituteWindow.jqmShow();
		}

		newSubstituteComponentClicked = function() {
			editSubstituteComponentWindow = $('#editSubstituteComponentWindow').jqm({ajax: 'substitute/editSubstituteComponent.html?substituteId='+substitutesGrid.getSelectedRow()});
			editSubstituteComponentWindow.jqmShow();
		}

		editSubstituteApplyClick = function() {
			var substituteData = $('#substituteForm').serializeObject();
			$(".validatorGlobalMessage").html('');
			$(".fieldValidatorMessage").html('');
			$.ajax({
				url: 'substitute/editSubstitute/save.html',
				type: 'POST',
				data: substituteData,
				success: function(response) {
					if (response.valid) {
						editSubstituteWindow.jqmHide();
						substitutesGrid.refresh();
					} else {
						$(".validatorGlobalMessage").html(response.globalMessage);
						for (var field in response.fieldMessages) {
							$("#"+field+"_validateMessage").html(response.fieldMessages[field]);
						}
					}
				},
				error: function(xhr, textStatus, errorThrown){
					alert(textStatus);
				}
	
			});
			return false;
		}

		editSubstituteComponentApplyClick = function() {
			var substituteData = $('#substituteComponentForm').serializeObject();
			$(".validatorGlobalMessage").html('');
			$(".fieldValidatorMessage").html('');
			$.ajax({
				url: 'substitute/editSubstituteComponent/save.html',
				type: 'POST',
				data: substituteData,
				success: function(response) {
					if (response.valid) {
						editSubstituteComponentWindow.jqmHide();
						substituteComponentsGrid.refresh();
					} else {
						$(".validatorGlobalMessage").html(response.globalMessage);
						for (var field in response.fieldMessages) {
							$("#"+field+"_validateMessage").html(response.fieldMessages[field]);
						}
					}
				},
				error: function(xhr, textStatus, errorThrown){
					alert(textStatus);
				}
	
			});
			return false;
		}
		
	</script>
		
		
		<div>
			Substytuty:
			<button id="newSubstituteButton" onClick="newSubstituteClicked()"><spring:message code="productsFormView.new"/></button>
			<button id="deleteSubstituteButton" onClick="substitutesGrid.deleteSelectedRecords()"><spring:message code="productsFormView.delete"/></button>
			<button id="upSubstituteButton" onClick="console.info('not implemented')"><spring:message code="productsFormView.up"/></button>
			<button id="downSubstituteButton" onClick="console.info('not implemented')"><spring:message code="productsFormView.down"/></button>
		</div>
		<table id="substitutesGrid"></table>
		<div>
			Produkty substytutu:
			<button id="newSubstituteComponentButton" onClick="newSubstituteComponentClicked()"><spring:message code="productsFormView.new"/></button>
			<button id="deleteSubstituteComponentButton" onClick="substituteComponentsGrid.deleteSelectedRecords()"><spring:message code="productsFormView.delete"/></button>
		</div>
		<table id="substituteComponentsGrid"></table> 
		
		<div class="jqmWindow" id="editSubstituteWindow">
			Please wait...
		</div>
		
		<div class="jqmWindow" id="editSubstituteComponentWindow">
			Please wait...
		</div>




