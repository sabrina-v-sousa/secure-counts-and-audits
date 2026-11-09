package com.securecounts;

import com.azure.communication.common.*;
import com.azure.communication.identity.*;
import com.azure.communication.identity.models.*;
import com.azure.core.credential.*;

import java.io.IOException;
import java.time.*;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TokenServlet extends HttpServlet {
    private CommunicationIdentityClient communicationIdentityClient;

    @Override
    public void init() throws ServletException {
        String conn = System.getenv("CONN_STRING1");
        if (conn == null || conn.isBlank()) {
            throw new ServletException("CONN_STRING1 is not visible to this Tomcat process");
        }
        communicationIdentityClient = new CommunicationIdentityClientBuilder()
            .connectionString(conn)
            .buildClient();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CommunicationTokenScope> scopes = Arrays.asList(CommunicationTokenScope.VOIP);
        CommunicationUserIdentifierAndToken result =
            communicationIdentityClient.createUserAndToken(scopes);
        response.setContentType("application/json");
        AccessToken accessToken = result.getUserToken();
        OffsetDateTime expiresAt = accessToken.getExpiresAt();
        String token = accessToken.getToken();
        CommunicationUserIdentifier user = result.getUser();
        response.getWriter().write("{\"userId\":\"" + user.getId() + "\",\"token\":\"" + token + "\"}");
    }
}