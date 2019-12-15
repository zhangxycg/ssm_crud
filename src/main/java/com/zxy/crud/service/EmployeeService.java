package com.zxy.crud.service;

import com.zxy.crud.bean.Employee;
import com.zxy.crud.bean.EmployeeExample;
import com.zxy.crud.bean.EmployeeExample.Criteria;
import com.zxy.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author: zhangxy
 * @Date: Created in 2019/12/10
 */
@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 查询所有员工
     *
     * @return
     */
    public List<Employee> getAll() {

        return employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * 员工保存
     *
     * @param employee
     */
    public void saveEmp(Employee employee) {
        // 有选择的插入
        employeeMapper.insertSelective(employee);
    }

    /**
     * 检验用户名是否可用
     *
     * @param empName
     * @return true：代表当前用户名可用
     */
    public boolean checkUser(String empName) {

        EmployeeExample example = new EmployeeExample();
        Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        // 记录数
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }

    /**
     * 根据员工id查询员工
     *
     * @param id
     * @return
     */
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    /**
     * 员工更新
     * @param employee
     */
    public void updateEmp(Employee employee) {

        employeeMapper.updateByPrimaryKeySelective(employee);
    }
}
