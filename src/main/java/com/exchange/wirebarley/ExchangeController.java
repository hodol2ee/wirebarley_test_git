package com.exchange.wirebarley;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpEntity;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ExchangeController
{
	private static final Logger logger = LoggerFactory.getLogger(ExchangeController.class);
	
	public static final String ACCESS_KEY = "5a4ee9dd5ebd33314cdd5510af81d766";
    public static final String BASE_URL = "http://apilayer.net/api/";
    public static String ENDPOINT = "live";
    public static String REMITTANCE_COUNTRY = "USD";
    public static String RECIPIENT_COUNTRY = "KRW,JPY,PHP";
    public static String API_FORMAT = "1";
    
    static CloseableHttpClient httpClient = HttpClients.createDefault();
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView exchange(HttpServletRequest request) throws Exception
	{
		logger.info("ExchangeController.exchange:::");
		
		ModelAndView mav = new ModelAndView("exchange");
		
		JSONObject exchangeRates = sendLiveRequest();
		
		mav.addObject("exchangeRates", exchangeRates);
		
		return mav;
	}
	
	public JSONObject sendLiveRequest()
	{
		// The following line initializes the HttpGet Object with the URL in order to send a request
		HttpGet get = new HttpGet(BASE_URL + ENDPOINT + "?access_key=" + ACCESS_KEY + "&currencies=" + RECIPIENT_COUNTRY + "&source=" + REMITTANCE_COUNTRY + "&format=" + API_FORMAT);
		JSONObject exchangeRates = null;
		
		try
		{
			CloseableHttpResponse response =  httpClient.execute(get);
			HttpEntity entity = response.getEntity();
			
			// the following line converts the JSON Response to an equivalent Java Object
			exchangeRates = new JSONObject(EntityUtils.toString(entity));
			response.close();
		}
		catch (ClientProtocolException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (ParseException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (JSONException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return exchangeRates;
	}
}
