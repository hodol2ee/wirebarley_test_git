package com.exchange.wirebarley;

import org.json.JSONObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
"file:src/test/resources/appServlet/servlet-context.xml",
"file:src/test/resources/root-context.xml"}
)
public class ExchangeTest
{
	private static final Logger logger = LoggerFactory.getLogger(ExchangeTest.class);
	
	@Autowired
	private ExchangeController exchangeController;

    @Test
    public void sendLiveRequestTest()
    {
    	JSONObject exchangeRates = exchangeController.sendLiveRequest();
    	
    	logger.info("exchangeRates::: {}", exchangeRates);
    }
    
}