<%@ page language="java"  pageEncoding="UTF-8"%>
<script type="text/javascript">
var budget_audit_datagrid;
$(function ()
{
    budget_audit_datagrid = $('#budget_audit_datagrid').datagrid(
        {
            url : '${pageContext.request.contextPath}/budgetAction!do_datagrid.action',
            queryParams :{deptId:'${sessionInfo.deptId}',cstate:1},
            pagination : true,
            pageSize : 10,
            pageList : [10, 20, 30, 40],
            border : false,
            fit : true,
            idField : 'cid',
            sortName : 'ccreatedate',
            sortOrder : 'desc',
            checkOnSelect : false,
            selectOnCheck : true,
            frozenColumns : [ [ {
				title:'编号',
				field:'cid',
				width:80,
				align:'center',
				checkbox : true
			},{
				title:'单位',
				field:'deptName',
				align:'center',
				width:100
			},
			{
                title : '归属办法字号',
                field : 'fileNumber',
                align : "center",
                width : 150
            },
            {
                title : '归属办法名称',
                field : 'fileName',
                align : "center",
                width : 200,
                formatter : function(value, rowData, rowIndex) {
					return sy.fs('<a href="{0}" target="_blank" >{1}</a>',"${pageContext.request.contextPath}"+rowData.filePath,rowData.fileName);
				}
            }]],
            columns : [[
                    {
                        title : '所属专业',
                        field : 'zrzxName',
                        align : "center",
                        width : 120
                    },
                    {
                        title : '归属项目',
                        field : 'projectName',
                        align : "center",
                        width : 120
                    },
                    {
                        title : '预计业务量收',
                        field : 'cyjywls',
                        align : "center",
                        width : 120,
                        sortable : true
                    },
                    {
                        title : '预计费用（不含税）',
                        field : 'cyjfy',
                        align : "center",
                        width : 180
                    },
                    {
                        title : '预计利润',
                        field : 'cyjlr',
                        width : 80,
                        align : "center"
                    },
                    {
                        title : '预计清算时间',
                        field : 'cyjqssj',
                        align : "center",
                        width : 80
                    },
                    {
                        title : '创建日期',
                        field : 'ccreatedate',
                        align : "center",
                        width : 80
                    },
                    {
                        title : '状态',
                        field : 'cstate',
                        align : "center",
                        width : 80,
                        formatter:function(value, row, index) {
                        	if (value==0){
                        		return "未提交审核";
                        	}
                        	else
                        		{
                        		  if (value==1){
                        			  return "等待审核";
                        		  }	else{
                        			  if (value==2){
                        				  return "审核未通过";
                        			  }else{
                        				  if (value==3){
                        					  return "已审核通过";  
                        				  }
                        			  }
                        		  }
                        		}
                        }
                    },
                    {
                        title : '单位ID',
                        field : 'deptId',
                        width : 80,
                        align : "center",
                        hidden : true
                    },
                    {
                        title : '用户ID',
                        field : 'userID',
                        align : "center",
                        width : 80,
                        hidden : true
                    },
                    {
                        title : '责任中心ID',
                        field : 'zrzxId',
                        align : "center",
                        width : 80,
                        hidden : true
                    },
                    {
                        title : '归属项目ID',
                        field : 'projectId',
                        align : "center",
                        width : 80,
                        hidden : true
                    },
                    {
                        title : '归属办法ID',
                        field : 'fileId',
                        align : "center",
                        width : 100 ,
                        hidden : true
                    },
                    {
                        title : '考核开始时间',
                        field : 'startdate',
                        align : "center",
                        width : 100 ,
                        hidden : true
                    },
                    {
                        title : '考核结束时间',
                        field : 'enddate',
                        align : "center",
                        width : 100 ,
                        hidden : true
                    }
                ]],
            toolbar : [
                {
                    text : '查看',
                    iconCls : 'icon-view',
                    handler : function ()
                    {
                    	budgetAuditView();
                    }
                }, '-',
                {
                    text : '审核通过',
                    iconCls : 'icon-ok',
                    handler : function ()
                    {
                        budgetAudit();
                    }
                }, '-',
                {
                    text : '审核不通过',
                    iconCls : 'icon-no',
                    handler : function ()
                    {
                        budgetNotAudit();
                    }
                }, '-',
                {
                    text : '修改',
                    iconCls : 'icon-edit',
                    handler : function ()
                    {
                    	budgetAuditEdit();
                    }
                }, '-',
                {
                    text : '删除',
                    iconCls : 'icon-delete',
                    handler : function ()
                    {
                    	budgetAuditRemove();
                    }
                }, '-']
        }
        );
    $('#budget_audit_deptid').val('${sessionInfo.deptId}');
    
}
);

function budgetAuditView()
{
	var rows = budget_audit_datagrid.datagrid('getChecked');
	if (rows.length == 1) {
    	var p = parent.sy.dialog(
        {
            title : '重点业务费预算查看',
            iconCls : 'icon-view',
            href : '${pageContext.request.contextPath}/budgetAction!budgetView.action',
            width : 660,
            height : 350,
            buttons : [
                       {
                           text : '关闭',
                           iconCls : 'icon-exit',
                           handler : function (){
                        	   p.dialog('close');
                        	   }
                           }],
            onLoad : function ()
            {
            	 var f = p.find('form');
                 f.form('load',rows[0]);
                 f.find('a').attr('href','${pageContext.request.contextPath}'+rows[0].filePath);
                 f.find('span').html(rows[0].fileName);
            }
        }
        );
    }
	else
		 if (rows.length > 1) {
				parent.sy.messagerAlert('提示', '只能选择一条记录查看！', 'info');
			} else {
				parent.sy.messagerAlert('提示', '请选择要查看的记录！', 'info');
			}
};

function budgetAuditEdit()
{
	var rows = budget_audit_datagrid.datagrid('getChecked');
	if (rows.length == 1 ) {
   		 var p = parent.sy.dialog(
        {
            title : '重点业务费预算修改',
            iconCls : 'icon-edit',
            href : '${pageContext.request.contextPath}/budgetAction!budgetEdit.action',
            width : 580,
            height : 300,
            buttons : [
                {
                    text : '保存',
                    iconCls : 'icon-save',
                    handler : function ()
                    {
                        var f = p.find('form');
                        f.form('submit',
                        {
                            url : '${pageContext.request.contextPath}/budgetAction!edit.action',
                            success : function (d)
                            {
                                var json = $
                                    .parseJSON(d);
                                if (json.success)
                                {
                                    budget_audit_datagrid.datagrid('reload');
                                    budget_audit_datagrid.datagrid('unselectAll');
                                    p.dialog('close');
                                }
                                parent.sy.messagerShow(
                                {
                                    msg : json.msg,
                                    title : '提示'
                                }
                                );
                            }
                        }
                        );
                    }
                }
            ],
            onLoad : function ()
            {
                var f = p.find('form');
                f.form('load',rows[0]);
            }
        }
        );
	 }
	else
		 if (rows.length > 1) {
				parent.sy.messagerAlert('提示', '只能选择一条记录编辑！', 'info');
			} else {
				parent.sy.messagerAlert('提示', '请选择要编辑的记录！', 'info');
			}
};

function budgetAuditRemove()
{
    var rows = budget_audit_datagrid.datagrid('getChecked');
    var ids = [];
    if (rows.length > 0)
    {
        parent.sy.messagerConfirm('请确认', '是否删除当前所选重点业务费预算？', function (r)
        {
            if (r)
            {
                for (var i = 0; i < rows.length; i++)
                {
                    ids.push(rows[i].cid);
                }
                $.ajax(
                {
                    url : '${pageContext.request.contextPath}/budgetAction!delete.action',
                    data :
                    {
                        ids : ids.join(',')
                    },
                    dataType : 'json',
                    success : function (d)
                    {
                        budget_audit_datagrid.datagrid('load');
                        budget_audit_datagrid.datagrid('unselectAll');
                        parent.sy.messagerShow(
                        {
                            title : '提示',
                            msg : d.msg
                        }
                        );
                    }
                }
                );
            }
        }
        );
    }
    else
    {
        parent.sy.messagerAlert('提示', '请选择要删除的记录！', 'error');
    }
};
function budgetAudit()
{
	 var rows = budget_audit_datagrid.datagrid('getChecked');
	    var ids = [];
	    if (rows.length > 0)
	    {
	        parent.sy.messagerConfirm('请确认', '是否审核通过当前所选重点业务费预算？', function (r)
	        {
	            if (r)
	            {
	                for (var i = 0; i < rows.length; i++)
	                {
	                    ids.push(rows[i].cid);
	                }
	                $.ajax(
	                {
	                    url : '${pageContext.request.contextPath}/budgetAction!audit.action',
	                    data :
	                    {
	                        ids : ids.join(',')
	                    },
	                    dataType : 'json',
	                    success : function (d)
	                    {
	                        budget_audit_datagrid.datagrid('load');
	                        budget_audit_datagrid.datagrid('unselectAll');
	                        parent.sy.messagerShow(
	                        {
	                            title : '提示',
	                            msg : d.msg
	                        }
	                        );
	                    }
	                }
	                );
	            }
	        }
	        );
	    }
	    else
	    {
	        parent.sy.messagerAlert('提示', '请选择要审核的记录！', 'error');
	    }
	};
	
	function budgetNotAudit()
	{
		 var rows = budget_audit_datagrid.datagrid('getChecked');
		    var ids = [];
		    if (rows.length > 0)
		    {
		        parent.sy.messagerConfirm('请确认', '是否审核不通过当前所选重点业务费预算？', function (r)
		        {
		            if (r)
		            {
		                for (var i = 0; i < rows.length; i++)
		                {
		                    ids.push(rows[i].cid);
		                }
		                $.ajax(
		                {
		                    url : '${pageContext.request.contextPath}/budgetAction!notAudit.action',
		                    data :
		                    {
		                        ids : ids.join(',')
		                    },
		                    dataType : 'json',
		                    success : function (d)
		                    {
		                        budget_audit_datagrid.datagrid('load');
		                        budget_audit_datagrid.datagrid('unselectAll');
		                        parent.sy.messagerShow(
		                        {
		                            title : '提示',
		                            msg : d.msg
		                        }
		                        );
		                    }
		                }
		                );
		            }
		        }
		        );
		    }
		    else
		    {
		        parent.sy.messagerAlert('提示', '请选择要审核的记录！', 'error');
		    }
		};
		
function budgetAuditDelete(cid)
{
    $('#budget_audit_datagrid').datagrid('uncheckAll').datagrid('unselectAll').datagrid('clearSelections');
    $('#budget_audit_datagrid').datagrid('checkRow', $('#budget_audit_datagrid').datagrid('getRowIndex', cid));
    budgetAuditRemove();
};


function _searchBudgetAudit() {
	budget_audit_datagrid.datagrid('load', sy.serializeObject($('#budget_audit_search_form')));
};
function cleanSearchBudgetAudit() {
	$('#budget_audit_search_form table input[name!=deptId]').val('');
	budget_audit_datagrid.datagrid('load', sy.serializeObject($('#budget_audit_search_form')));
};
</script>
<div class="easyui-layout" data-options="fit:true" style="overflow: hidden;">
	<div data-options="region:'north',title:'查询预算（支持模糊查询）',iconCls:'icon-search'" style="height: 200px;padding:5px;border-bottom:none;overflow: hidden;">
		<form id="budget_audit_search_form">
			<table style="height: 100%;" class="input_table">
				<tr>
				    <th width="100px">所属单位：</th>
					<td width="150px"><input  id="budget_audit_deptid" class="easyui-combotree" name="deptId" data-options="url:'deptAction!do_showDept.action?cid=${sessionInfo.deptId }',panelHeight:'auto',required:true" /></td>
				    <th width="100px">归属办法名称：</th>
				    <td width="150px"><input type="text" name="fileName" /></td>
				  </tr>
				  <tr>
				    <th>所属专业：</th>
				    <td><input class="easyui-combobox" name="zrzxId" data-options="url:'zrzxAction!do_combobox.action',panelHeight:'auto',valueField:'cid',textField:'cname'" /></td>
				    <th>归属项目：</th>
				    <td><input class="easyui-combobox" name="projectId" data-options="url:'projectAction!do_combobox.action',panelHeight:'auto',valueField:'cid',textField:'cname'" /></td>
				  </tr>
				  <tr>
				    <th>创建起始日期：</th>
				    <td><input class="easyui-my97" type="text" name="createStartDate" data-options="dateFmt:'yyyy-MM-dd'" /></td>
				    <th>创建结束日期：</th>
				    <td><input class="easyui-my97" type="text" name="createEndDate" data-options="dateFmt:'yyyy-MM-dd'" /></td>
				  </tr>
				  <tr>
				    <td colspan="2" align="center"><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="_searchBudgetAudit();">开始查询</a></td>
				    <td colspan="2" align="center"><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'" onClick="cleanSearchBudgetAudit();">清空条件</a></td>
				  </tr>
			</table>
		</form>
	</div>
	<div data-options="region:'center',title:'重点业务费预算列表',border:true" style="overflow: hidden;">
		<table id="budget_audit_datagrid"></table>
	</div>
</div>
