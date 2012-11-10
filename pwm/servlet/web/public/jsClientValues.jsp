<%--
~ Password Management Servlets (PWM)
~ http://code.google.com/p/pwm/
~
~ Copyright (c) 2006-2009 Novell, Inc.
~ Copyright (c) 2009-2012 The PWM Project
~
~ This program is free software; you can redistribute it and/or modify
~ it under the terms of the GNU General Public License as published by
~ the Free Software Foundation; either version 2 of the License, or
~ (at your option) any later version.
~
~ This program is distributed in the hope that it will be useful,
~ but WITHOUT ANY WARRANTY; without even the implied warranty of
~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
~ GNU General Public License for more details.
~
~ You should have received a copy of the GNU General Public License
~ along with this program; if not, write to the Free Software
~ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--%>

<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="password.pwm.ContextManager" %>
<%@ page import="password.pwm.PwmApplication" %>
<%@ page import="password.pwm.PwmConstants" %>
<%@ page import="password.pwm.PwmSession" %>
<%@ page import="password.pwm.config.Display"%>
<%@ page import="password.pwm.config.FormConfiguration"%>
<%@ page import="password.pwm.util.stats.Statistic"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Locale"%><%@ page import="java.util.ResourceBundle"%><%@ page import="java.util.TreeSet"%>
<% final PwmSession pwmSession = PwmSession.getPwmSession(session); %>
<% final PwmApplication pwmApplication = ContextManager.getPwmApplication(session); %>
<% response.setHeader("Cache-Control","private, max-age=" + PwmConstants.RESOURCE_SERVLET_EXPIRATION_SECONDS); %>
<%@ page language="java" session="true" isThreadSafe="true" contentType="text/javascript; charset=UTF-8" %>
<%@ taglib uri="pwm" prefix="pwm" %>
PWM_GLOBAL={};
PWM_STRINGS={};
function initPwmStringValues() {
PWM_GLOBAL['pwmFormID'] = '<pwm:FormID/>';
PWM_GLOBAL['MaxInactiveInterval']='<%=request.getSession().getMaxInactiveInterval()%>';
<% final ResourceBundle bundle = ResourceBundle.getBundle(Display.class.getName()); %>
<% final Locale userLocale = pwmSession.getSessionStateBean().getLocale() == null ? PwmConstants.DEFAULT_LOCALE : pwmSession.getSessionStateBean().getLocale(); %>
<% for (final String key : new TreeSet<String>(Collections.list(bundle.getKeys()))) { %>
    PWM_STRINGS['<%=key%>']='<%=StringEscapeUtils.escapeJavaScript(Display.getLocalizedMessage(userLocale,key,pwmApplication.getConfig()))%>';
<% } %>
}

function initPwmGlobalValues() {
<% if (pwmApplication.getConfig() != null) { %>
    PWM_GLOBAL['setting-showHidePasswordFields'] = <%=pwmApplication.getConfig().readSettingAsBoolean(password.pwm.config.PwmSetting.DISPLAY_SHOW_HIDE_PASSWORD_FIELDS)%>;
<% } %>
    PWM_GLOBAL['url-logout'] = "<%=request.getContextPath()%><pwm:url url='/public/Logout?idle=true'/>";
    PWM_GLOBAL['url-command'] = "<%=request.getContextPath()%><pwm:url url='/public/CommandServlet'/>";
    PWM_GLOBAL['url-resources'] = "<%=request.getContextPath()%><pwm:url url='/resources'/>";
    PWM_GLOBAL['url-restservice'] = "<%=request.getContextPath()%><pwm:url url='/public/rest'/>";
    PWM_GLOBAL['url-setupresponses'] = '<pwm:url url='SetupResponses'/>';
    PWM_GLOBAL['clientAjaxTypingTimeout'] = <%=PwmConstants.CLIENT_AJAX_TYPING_TIMEOUT%>
            PWM_GLOBAL['formTypeOptions'] = [];
<% for (final FormConfiguration.Type type : FormConfiguration.Type.values()) { %>
    PWM_GLOBAL['formTypeOptions'].push('<%=type.toString()%>');
<%}%>
}

function initPwmLocaleVars() {
    var localeInfo = {};
    var localeDisplayNames = {};
<% for (final Locale locale : pwmApplication.getConfig().getKnownLocales()) { %>
<% final String flagCode = pwmApplication.getConfig().getKnownLocaleFlagMap().get(locale); %>
    createCSSClass('.flagLang_<%=locale.toString()%>','background-image: url(flags/png/<%=flagCode%>.png)');
    localeInfo['<%=locale.toString()%>'] = '<%=locale.getDisplayLanguage()%> - <%=locale.getDisplayLanguage(locale)%>';
    localeDisplayNames['<%=locale.toString()%>'] = '<%=locale.getDisplayLanguage()%>';
<% } %>
    PWM_GLOBAL['localeInfo'] = localeInfo;
    PWM_GLOBAL['localeDisplayNames'] = localeDisplayNames;
    PWM_GLOBAL['defaultLocale'] = '<%=PwmConstants.DEFAULT_LOCALE.toString()%>';
}

function initEpsTypes() {
    PWM_GLOBAL['epsTypes'] = [];
<% for (final Statistic.EpsType loopEpsType : Statistic.EpsType.values()) { %>
    PWM_GLOBAL['epsTypes'].push('<%=loopEpsType%>');
<% } %>
    PWM_GLOBAL['epsDurations'] = [];
<% for (final Statistic.EpsDuration loopEpsDuration : Statistic.EpsDuration.values()) { %>
    PWM_GLOBAL['epsDurations'].push('<%=loopEpsDuration%>');
<% } %>
}

function initPwmVariables() {
    initPwmGlobalValues();
    initPwmStringValues();
    initPwmLocaleVars();
    initEpsTypes();
}

initPwmVariables();