package com.weather;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 Starting Weather Email Scheduler...");
        // Start the daily email task
        WeatherEmailScheduler.startDailyEmailTask();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 Stopping Weather Email Scheduler...");
        WeatherEmailScheduler.stopScheduler();
    }
}
