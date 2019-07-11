package com.atguigu.gmall.service;

import com.atguigu.gmall.bean.*;

import java.util.HashMap;
import java.util.List;

public interface SpuService {
    List<SpuInfo> spuList(String catalog3Id);

    List<BaseSaleAttr> baseSaleAttrList();

    void saveSpu(SpuInfo spuInfo);

    List<SpuSaleAttr> getSaleAttrListBySpuId(String spuId);

    List<SpuImage> getSpuImageListBySpuId(String spuId);

    List<SpuSaleAttr> getSpuSaleAttrListCheckBySku(HashMap<String, String> stringStringHashMap);

    List<SkuInfo> getSkuSaleAttrValueListBySpu(String spuId);
}
