package com.atguigu.gmall.list;

import com.alibaba.dubbo.config.annotation.Reference;
import com.atguigu.gmall.bean.SkuInfo;
import com.atguigu.gmall.bean.SkuLsInfo;
import com.atguigu.gmall.service.SkuService;
import io.searchbox.client.JestClient;
import io.searchbox.core.Index;
import io.searchbox.core.Search;
import io.searchbox.core.SearchResult;
import org.apache.commons.beanutils.BeanUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
public class GmallListServiceApplicationTests {

    @Autowired
    JestClient jestClient;

    @Reference
    SkuService skuService;

    @Test
    public void search(){
        List<SkuLsInfo> skuLsInfos = new ArrayList<>();

    }

    @Test
    public void contextLoads() {
        //查询mysql中的sku信息
        List<SkuInfo> skuInfoList = skuService.getSkuListByCatalog3Id("5");

        //转化ES中的sku信息
        ArrayList<SkuLsInfo> skuLsInfos = new ArrayList<>();
        for (SkuInfo skuInfo : skuInfoList) {
            SkuLsInfo skuLsInfo = new SkuLsInfo();
            try {
                BeanUtils.copyProperties(skuLsInfo, skuInfo);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }

            skuLsInfos.add(skuLsInfo);
        }

        //导入到ES中
        for (SkuLsInfo skuLsInfo : skuLsInfos) {
            if(skuLsInfo.getId().equals("3")){
                System.out.println("====================>>id是3才添加!");
                Index build = new Index.Builder(skuLsInfo).index("gmall0328").type("SkuLsInfo").id(skuLsInfo.getId()).build();
                try {
                    jestClient.execute(build);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }

    }

}
