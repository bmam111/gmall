package com.atguigu.gmall.item.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.atguigu.gmall.bean.SkuInfo;
import com.atguigu.gmall.bean.SkuSaleAttrValue;
import com.atguigu.gmall.bean.SpuSaleAttr;
import com.atguigu.gmall.service.SkuService;
import com.atguigu.gmall.service.SpuService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;

@Controller
public class ItemController {

    @Reference
    SkuService skuService;

    @Reference
    SpuService spuService;

    @RequestMapping("{skuId}.html")
    public String item(@PathVariable String skuId, ModelMap map){

        SkuInfo skuInfo = skuService.getSkuById(skuId);
        map.put("skuInfo",skuInfo);

        String spuId = skuInfo.getSpuId();

/*        //当前sku所包含的销售属性
        List<SkuSaleAttrValue> skuSaleAttrValueList = skuInfo.getSkuSaleAttrValueList();

        //spu的销售属性列表
        List<SpuSaleAttr> spuSaleAttrs = spuService.getSaleAttrListBySpuId(spuId);*/

        //销售属性列表
        HashMap<String, String> stringStringHashMap = new HashMap<>();
        stringStringHashMap.put("spuId", spuId);
        stringStringHashMap.put("skuId", skuId);
        List<SpuSaleAttr> spuSaleAttrs = spuService.getSpuSaleAttrListCheckBySku(stringStringHashMap);
        map.put("spuSaleAttrListCheckBySku", spuSaleAttrs);


        List<SkuInfo> skuInfos = spuService.getSkuSaleAttrValueListBySpu(spuId);
        HashMap<String, String> stringStringHashMap1 = new HashMap<>();
        for (SkuInfo info : skuInfos) {
            String v = info.getId();
            String k = "";
            List<SkuSaleAttrValue> skuSaleAttrValueList = info.getSkuSaleAttrValueList();
            for (SkuSaleAttrValue skuSaleAttrValue : skuSaleAttrValueList) {
                k = k + "|" + skuSaleAttrValue.getSaleAttrValueId();
            }
            stringStringHashMap1.put(k,v);
        }
        String skuJson = JSON.toJSONString(stringStringHashMap1);
        map.put("skuJson", skuJson);


        return "item";
    }
}
