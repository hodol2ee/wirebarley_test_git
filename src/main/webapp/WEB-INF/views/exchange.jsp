<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko-KR">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<title>환율 계산</title>
	
	<script type="text/javaScript" src="/resources/common/js/jquery-1.7.2.min.js"></script>
</head>
<body>

<div class="content">
	<div class="table_area">
		<h1>
			환율 계산
		</h1>
		<table>
			<colgroup>
				<col style="width:100px"><col>
			</colgroup>
			<tbody>
				<tr>
					<th>송금국가&nbsp;:&nbsp;</th>
					<td>
						<select name="remittance_country">
							<option value="USD" selected="selected">미국(USD)</option>
							<option value="AUD">호주(AUD)</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>수취국가&nbsp;:&nbsp;</th>
					<td>
						<select name="recipient_country">
							<option value="KRW" selected="selected">한국(KRW)</option>
							<option value="JPY">일본(JPY)</option>
							<option value="PHP">필리핀(PHP)</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>환율&nbsp;:&nbsp;</th>
					<td>
						<span id="exchange_rate_text">0.00</span>&nbsp;<span id="remittance_text"></span>/<span id="recipient_text"></span>
					</td>
				</tr>
				<tr>
					<th>송금액&nbsp;:&nbsp;</th>
					<td>
						<input type="text" name="remittance_amount" value="100" style="width:80px;">&nbsp;<span id="remittance_amount_text">USD</span>
					</td>
				</tr>
			</tbody>
		</table>	
	</div>
	<div class="button_area">
		<button type="button" name="exchange_btn">Submit</button>
	</div>
	<div class="exchangeConvert" style="margin-top:20px;">
		<span id="exchange_convert_text"></span>
	</div>
</div>

<script type="text/javascript">
var exchangeRates = JSON.parse('${exchangeRates}');

$(document).ready(function () {
	fn_init_assemble._init_exchange_rate();
	fn_events_assemble._event_recipient_country_change();
	fn_events_assemble._event_remittance_amount_change();
	fn_events_assemble._event_exchange_btn();
});

var fn_init_assemble = {
	_init_exchange_rate : function(){
		var remittance_country = $("select[name=remittance_country]").val();
		var recipient_country = $("select[name=recipient_country]").val();
		var exchange_country = remittance_country + recipient_country;
		var exchange_quotes = exchangeRates.quotes;
		var exchange_rate = 0.00;
		
		if(exchange_country == "USDKRW")
		{
			exchange_rate = exchange_quotes.USDKRW.toFixed(2);
			exchange_rate = exchange_rate.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		else if(exchange_country == "USDJPY")
		{
			exchange_rate = exchange_quotes.USDJPY.toFixed(2);
			exchange_rate = exchange_rate.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		else if(exchange_country == "USDPHP")
		{
			exchange_rate = exchange_quotes.USDPHP.toFixed(2);
			exchange_rate = exchange_rate.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		$("span#exchange_rate_text").text(exchange_rate);
		$("span#remittance_text").text(remittance_country);
		$("span#recipient_text").text(recipient_country);
		$("span#remittance_amount_text").text(remittance_country);
	}
}

var fn_events_assemble = {
	_event_recipient_country_change : function(){
		$("select[name=recipient_country]").off().on("change", function(){
			fn_init_assemble._init_exchange_rate();
		});
	},
	_event_remittance_amount_change : function(){
		$("input[name=remittance_amount]").off().on("change", function(){
			
			var remittance_amount = $("input[name=remittance_amount]").val();
			
			if (fn_validation_assemble._validationNumberRegExp(remittance_amount))
    		{
    			alert("송금액이 바르지 않습니다.");
    			$("input[name=remittance_amount]").focus();
    			return false;
    		}
			else
			{
				if (remittance_amount < 1 || remittance_amount > 10000)
	    		{
	    			alert("송금액이 바르지 않습니다.");
	    			$("input[name=remittance_amount]").focus();
	    			return false;
	    		}
			}
		});
	},
	_event_exchange_btn : function(){
		$("button[name=exchange_btn]").off().on("click", function(){
			var params = new Object();
			
			var remittance_country = $("select[name=remittance_country]").val();
			var recipient_country = $("select[name=recipient_country]").val();
			var remittance_amount = $("input[name=remittance_amount]").val();
			
			if(remittance_country == null || remittance_country == "")
			{
				alert("송금국가를 선택하세요.");
				$("select[name=remittance_country]").focus();
				return false;
			}
			else
			{
				if(remittance_country == "AUD")
				{
					alert("무료 API는 송금국가를 변경 할 수 없습니다.");
					$("select[name=remittance_country]").val("USD");
					return false;
				}
			}
			
			if(recipient_country == null || recipient_country == "")
			{
				alert("수취국가를 선택하세요.");
				$("select[name=recipient_country]").focus();
				return false;
			}
			
			if (fn_validation_assemble._validationNumberRegExp(remittance_amount))
    		{
    			alert("송금액이 바르지 않습니다.");
    			$("input[name=remittance_amount]").focus();
    			return false;
    		}
			else
			{
				if (remittance_amount < 1 || remittance_amount > 10000)
	    		{
	    			alert("송금액이 바르지 않습니다.");
	    			$("input[name=remittance_amount]").focus();
	    			return false;
	    		}
			}
			
			params.remittance_country = remittance_country;
			params.recipient_country = recipient_country;
			params.remittance_amount = parseInt(remittance_amount);
			
			fn_grid_assemble._grid_exchangeConvert(params);
		});
	}
}

var fn_grid_assemble = {
	_grid_exchangeConvert : function(params) {
		var exchange_country = params.remittance_country + params.recipient_country;
		var exchange_quotes = exchangeRates.quotes;
		var exchange_rate = 0.00;
		var exchange_convert = 0.00;
		
		if(exchange_country == "USDKRW")
		{
			exchange_rate = exchange_quotes.USDKRW;
		}
		else if(exchange_country == "USDJPY")
		{
			exchange_rate = exchange_quotes.USDJPY;
		}
		else if(exchange_country == "USDPHP")
		{
			exchange_rate = exchange_quotes.USDPHP;
		}
		
		exchange_convert = exchange_rate * params.remittance_amount;
		exchange_convert = exchange_convert.toFixed(2);
		exchange_convert = exchange_convert.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		
		$("span#exchange_convert_text").text("수취금액은 " + exchange_convert + " " + params.recipient_country + " 입니다.");
	}
}

var fn_validation_assemble = {
	_validationRegExp : function(pattern, data) {
		return data.match(pattern);
	},
	_validationSpecialCharRegExp : function(data) {
		var regExpPattern = /[~!\?@\\$%<>^&\\’]/g;
		return fn_validation_assemble._validationRegExp(regExpPattern, data);
	},
	_validationNumberRegExp : function(data) {
		var regExpPattern = /[^0-9]/g;
		return fn_validation_assemble._validationRegExp(regExpPattern, data);
	},
	_validationSmEngNumRegExp : function(data) {
		var regExpPattern = /^[a-z0-9]*$/g;
		return fn_validation_assemble._validationRegExp(regExpPattern, data);
	},
	_validationHanEngRegExp : function(data) {
		var regExpPattern = /^[ㄱ-ㅎ가-힣A-Za-z]*$/g;
		return fn_validation_assemble._validationRegExp(regExpPattern, data);
	},
	_validationEmailRegExp : function(data) {
		var regExpPattern = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,}$/i;
		return fn_validation_assemble._validationRegExp(regExpPattern, data);
	}
}
</script>

</body>
</html>
