<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>员工列表</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:8080)；需要加上项目名
		http://localhost:8080/crud
 -->
    <script type="text/javascript"
            src="static/js/jquery3.4.1.min.js"></script>
    <link
            href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
            rel="stylesheet">
    <script
            src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="email@126.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value=""> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!-- 部门不是写死，从数据库查询。部门提交部门id即可 -->
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 搭建显示页面 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </div>
    </div>
    <!-- 显示分页信息 -->
    <div class="row">
        <!-- 分页文字信息 -->
        <div class="col-md-6" id="page_info_area">

        </div>
        <!-- 分页导航条信息 -->
        <div class="col-md-6" id="page_nav_area">
            <nav aria-label="Page navigation">
                <ul class="pagination">

                </ul>
            </nav>
        </div>
    </div>
</div>
<script type="text/javascript">
    // 页面加载完成以后，发送Ajax请求，要到分页数据
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "get",
            success: function (result) {
                //console.log(result)
                // 解析并显示员工数据
                build_emps_table(result);
                // 解析并显示分页信息
                build_page_info(result);
                // 解析并显示分页条
                build_page_nav(result);
            }
        })
    }

    function build_emps_table(result) {
        // 清空表格
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        // 遍历员工数据 index是索引，item是当前对象
        $.each(emps, function (index, item) {
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                .append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            // append 方法执行完成以后还是返回原来的元素
            $("<tr></tr>").append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        })
    }

    // 解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前 " + result.extend.pageInfo.pageNum + " 页，" +
            "总 " + result.extend.pageInfo.pages + " 页，总 " + result.extend.pageInfo.total + " 条记录")
    }

    // 解析显示分页导航条
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination")
        // 首页li
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        // 前一页li
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        // 判断有没有前一页
        if (result.extend.pageInfo.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            // 为元素添加翻页的事件
            firstPageLi.click(function () {
                to_page(1)
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }

        // 后一页li
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        // 末页li
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        // 判断有没有下一页
        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }

        // 添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        // 遍历给ul中添加页码提示
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum == item) {
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            })
            ul.append(numLi);
        });
        // 添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        // 把ul加入到nav元素中
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
    // 点击新增按钮，弹出模态框
    $("#emp_add_modal_btn").click(function () {
        // 发送Ajax请求，查出部门信息显示在下拉列表中
        getDepts("#empAddModal select");
        // 打开用于新增的模态框，并设置属性，点击其他地方时此模态框不会关闭
        $("#empAddModal").modal({
            backdrop: "static"
        })
    });
    // 查出所有的部门信息并显示在下拉列表中
    function getDepts() {
        $.ajax({
            url:"${APP_PATH}/depts",
            type: "GET",
            success:function (result) {
                // 在下拉列表中显示部门信息
                // 遍历部门信息
                $.each(result.extend.depts,function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo("#empAddModal select");
                });
            }
        });
    }
</script>
</body>
</html>
