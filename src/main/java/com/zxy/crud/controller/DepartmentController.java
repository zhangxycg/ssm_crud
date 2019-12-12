package com.zxy.crud.controller;

import com.zxy.crud.bean.Department;
import com.zxy.crud.bean.Msg;
import com.zxy.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Description: 处理和部门有关的请求
 * @Author: zhangxy
 * @Date: Created in 2019/12/12
 */
@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    /**
     * 返回所有的部门信息
     * @return
     */
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts() {
        // 显示所有的部门信息
        List<Department> list = departmentService.getDepts();
        return Msg.success().add("depts",list);
    }
}
