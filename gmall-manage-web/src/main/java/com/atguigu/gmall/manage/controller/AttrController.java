package com.atguigu.gmall.manage.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.atguigu.gmall.bean.BaseAttrInfo;
import com.atguigu.gmall.bean.BaseAttrValue;
import com.atguigu.gmall.service.AttrService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class AttrController {

    @Reference
    AttrService attrService;

    @RequestMapping("saveAttr")
    @ResponseBody
    public String saveAttr(BaseAttrInfo baseAttrInfo){

        System.out.println("==================");
        System.out.println("===>>baseAttrInfo.id:" + baseAttrInfo.getId());
        System.out.println("===>>baseAttrInfo.attrName:" + baseAttrInfo.getAttrName());
        System.out.println("===>>baseAttrInfo.catalog3Id:" + baseAttrInfo.getCatalog3Id());
        System.out.println("===>>baseAttrInfo.attrValueList:" + baseAttrInfo.getAttrValueList().size());
        for (BaseAttrValue baseAttrValue : baseAttrInfo.getAttrValueList()) {
            System.out.println(baseAttrValue.getId() + "---" + baseAttrValue.getValueName()
                    + "---" + baseAttrValue.getAttrId() + "---" + baseAttrValue.getIsEnabled());
        }
        System.out.println("==================");

        attrService.saveAttr(baseAttrInfo);
        return "success";

    }

    @RequestMapping("getAttrList")
    @ResponseBody
    public List<BaseAttrInfo> getAttrList(String catalog3Id){

        List<BaseAttrInfo> baseAttrInfos = attrService.getAttrList(catalog3Id);
        return baseAttrInfos;

    }

    @RequestMapping("getAttrValueList")
    @ResponseBody
    public List<BaseAttrValue> getAttrValueList(String attrId){

        List<BaseAttrValue> baseAttrValues = attrService.getAttrValueList(attrId);
        return baseAttrValues;

    }

}
