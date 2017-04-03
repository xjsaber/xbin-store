<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
    $(function () {
        var dataid;
        var oTable1 = $('#table${random}').DataTable({
            "bPaginate": true,//分页工具条显示
            "sPaginationType" : "full_numbers",//分页工具条样式
            "bStateSave": true, //是否打开客户端状态记录功能,此功能在ajax刷新纪录的时候不会将个性化设定回复为初始化状态
            "bScrollCollapse": true, //当显示的数据不足以支撑表格的默认的高度
            "bLengthChange": true, //每页显示的记录数
            "bFilter": false, //搜索栏
            "bSort": true, //是否支持排序功能
            "bInfo": true, //显示表格信息
            "bAutoWidth": true, //自适应宽度
            "bJQueryUI": false,//是否开启主题
            "bDestroy": true,
            "bProcessing": true, //开启读取服务器数据时显示正在加载中……特别是大数据量的时候，开启此功能比较好
            "bServerSide": true,//服务器处理分页，默认是false，需要服务器处理，必须true
            "sAjaxDataProp": "aData",//是服务器分页的标志，必须有
            "sAjaxSource": "/category/getTableData.action",//通过ajax实现分页的url路径。
            "aoColumns": [//初始化要显示的列
                {
                    "mDataProp": "id",//获取列数据，跟服务器返回字段一致
                    "sClass": "center",//显示样式
                    "mRender": function (data, type, full) {//返回自定义的样式
                        dataid = data;
                        return "<label id='id" + data + "'>" + data + "</label>";
                    }
                },
                {
                    "mDataProp": "name",
                    "mRender": function (data, type, full) {//返回自定义的样式
                        return "<input type='text' id='name" + dataid + "' name='name' value='" + data + "' disabled='disabled'/>";

                    }
                },
                {
                    "mDataProp": "sortOrder",
                    "mRender": function (data, type, full) {//返回自定义的样式
                        return "<input type='text' id='sort" + dataid + "' name='sortOrder' value='" + data + "' disabled='disabled'/>";
                    }
                },
//                {
//                    "mDataProp" : "createTime",
//                    "mRender" : function(data, type, full) {
//                        return new Date(data)//处理时间显示
//                                .toLocaleString();
//                    }
//                },
                {
                    "mDataProp": "id",
                    "mRender": function (data, type, full) {//" + data.id + "
                        return "<button id='edit" + dataid + "' type='button' class='btn btn-block btn-primary' onclick=edit('" + dataid + "')>编辑</button>";
                    }
                },
                {
                    "mDataProp": "id",
                    "mRender": function (data, type, full) {
                        return "<button id='save" + dataid + "' type='button' class='btn btn-block btn-primary' onclick=submitForm('" + dataid + "')>保存 </button>"
                    }
                }],
            "oLanguage": { // 汉化
                "sUrl": "/plugins/datatables/language.json"
            },
        });
    });

    function edit(id) {
//        if (typeof($("#id" + id).attr("disabled")) == "undefined") {
//            $("#id" + id).attr("disabled", 'disabled');
//        } else {
//            $("#id" + id).removeAttr("disabled");
//        }
        if (typeof($("#name" + id).attr("disabled")) == "undefined") {
            $("#name" + id).attr("disabled", 'disabled');
        } else {
            $("#name" + id).removeAttr("disabled");
        }
        if (typeof($("#sort" + id).attr("disabled")) == "undefined") {
            $("#sort" + id).attr("disabled", 'disabled');
        } else {
            $("#sort" + id).removeAttr("disabled");
        }
        if ($("#edit" + id).text() == "取消编辑") {
            $("#edit" + id).text("编辑");
        } else {
            $("#edit" + id).text("取消编辑");
        }

    }

    function submitForm(id) {
        $.post("/save/category.action",
                {
                    id: $("#id" + id).text(),
                    name: $("#name" + id).val(),
                    sort_order: $("#sort" + id).val()

                }
                , function (data) {
                    if (data && data.status == 200) {
                        $("#success${random}").show();
                    } else {
                        $("#error${random}").show();
                    }
                }).error(function () {
            $("#error${random}").show();
        });
    }
</script>
<div id="success${random}" class="alert alert-success alert-dismissible" role="alert" hidden="hidden">
    <button type="button" class="close" aria-label="Close" onclick="$('#success${random}').hide();"><span
            aria-hidden="true">&times;</span></button>
    <strong>成功!</strong> 保存成功
</div>
<div id="error${random}" class="alert alert-error alert-dismissible" role="alert" hidden="hidden">
    <button type="button" class="close" aria-label="Close" onclick="$('#error${random}').hide();"><span
            aria-hidden="true">&times;</span></button>
    <strong>错误!</strong> 服务器错误 请稍后重试！
</div>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        商品类目维护
        <small>维护商品一级类目</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> 商品维护</a></li>
        <li><a href="#">一级类目维护</a></li>
    </ol>
</section>

<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-xs-12">
            <!-- /.box-header -->
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">一级商品分类列表</h3>

                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
                        <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-remove"></i></button>
                    </div>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <table id="table${random}" class="table table-bordered table-striped">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>名称</th>
                            <th>排序</th>
                            <th>编辑</th>
                            <th>保存</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        <tr>
                            <th>ID</th>
                            <th>名称</th>
                            <th>排序</th>
                            <th>编辑</th>
                            <th>保存</th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
            <!-- /.col-->
        </div>
    </div>
    <!-- ./row -->
</section>

