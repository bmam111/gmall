package com.atguigu.gmall.manage.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.atguigu.gmall.bean.*;
import com.atguigu.gmall.manage.mapper.*;
import com.atguigu.gmall.service.AttrService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.List;

@Service
public class AttrServiceImpl implements AttrService {

    @Autowired
    BaseAttrInfoMapper baseAttrInfoMapper;

    @Autowired
    BaseAttrValueMapper baseAttrValueMapper;

    @Override
    public List<BaseAttrInfo> getAttrList(String catalog3Id) {
        BaseAttrInfo baseAttrInfo = new BaseAttrInfo();
        baseAttrInfo.setCatalog3Id(catalog3Id);
        List<BaseAttrInfo> baseAttrInfos = baseAttrInfoMapper.select(baseAttrInfo);

        return baseAttrInfos;

    }

    @Override
    public void saveAttr(BaseAttrInfo baseAttrInfo) {
        if(!StringUtils.isEmpty(baseAttrInfo.getId())){
            //1.修改基本属性名
            baseAttrInfoMapper.updateByPrimaryKey(baseAttrInfo);
            //2.属性的属性值操作
            List<BaseAttrValue> attrValues = baseAttrInfo.getAttrValueList();
            List<String> ids = new ArrayList<>();
            //2.1 删除没有提交过来的数据
            for (BaseAttrValue attrValue : attrValues) {
                String id = attrValue.getId();
                if(!StringUtils.isEmpty(id)){
                    ids.add(id);
                }
            }

            //Example emaple = Example.builder(BaseAttrValue.class).select("").where("").
            if(ids.size() > 0){
                Example example = new Example(BaseAttrValue.class);
                Example.Criteria criteria = example.createCriteria();
                criteria.andNotIn("id", ids);
                criteria.andEqualTo("attrId", baseAttrInfo.getId());
                baseAttrValueMapper.deleteByExample(example);
            }

            for (BaseAttrValue attrValue : attrValues) {
                //2.2 提交过来的数据,如果有id就是修改
                if(!StringUtils.isEmpty(attrValue.getId())){
                    baseAttrValueMapper.updateByPrimaryKey(attrValue);
                }else{
                    //2.3 提交过来的数据,如果没有id就是新增
                    attrValue.setId(null);
                    attrValue.setAttrId(baseAttrInfo.getId());
                    baseAttrValueMapper.insert(attrValue);
                }
            }
        }else{
            baseAttrInfoMapper.insertSelective(baseAttrInfo);
            List<BaseAttrValue> attrValueList = baseAttrInfo.getAttrValueList();

            for (BaseAttrValue baseAttrValue : attrValueList) {
                baseAttrValue.setAttrId(baseAttrInfo.getId());
                baseAttrValueMapper.insert(baseAttrValue);
            }
        }
    }

    @Override
    public List<BaseAttrValue> getAttrValueList(String attrId) {
        BaseAttrValue baseAttrValue = new BaseAttrValue();
        baseAttrValue.setAttrId(attrId);
        return baseAttrValueMapper.select(baseAttrValue);
    }
}
