package com.zxy.crud.test;

import com.zxy.crud.bean.Department;
import com.zxy.crud.bean.Employee;
import com.zxy.crud.dao.DepartmentMapper;
import com.zxy.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * @Description: 测试dao层， spring的项目使用spring的单元测试，自动注入我们需要的组件
 * @Author: zhangxy
 * @Date: Created in 2019/12/10
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;
    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD() {

//        // 1.创建SpringIOC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        // 2.从IOC容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);

        System.out.println(departmentMapper);

        // 1.插入几个部门
//        departmentMapper.insertSelective(new Department(null,"开发部门"));
//        departmentMapper.insertSelective(new Department(null,"测试部门"));

        // 2.生成员工数据，测试员工插入
//        employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@126.com",3));

        // 3.批量插入多个员工
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null,uid,"M",uid+"@126.com",3));
        }
        System.out.println("批量完成");
    }
}
