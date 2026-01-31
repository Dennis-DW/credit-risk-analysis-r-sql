#Setup Folder and Connection
dir.create("presentation_plots", showWarnings = FALSE)
conn <- dbConnect(RSQLite::SQLite(), "pezesha_data.db")

#Daily Volume Query
query <- "
SELECT
    DATE(transaction_date) as day,
    COUNT(*) as transaction_volume
FROM
    transactions
WHERE
    transaction_date >= DATE((SELECT MAX(transaction_date) FROM transactions), '-30 days')
GROUP BY
    day
ORDER BY
    day;
"
df_trend <- dbGetQuery(conn, query)

#Process Data
#Convert the 'day' string to a real Date object for proper plotting
df_trend$day <- as.Date(df_trend$day)

#Create Area Chart (Trend)
plot <- ggplot(df_trend, aes(x = day, y = transaction_volume)) +
  # Area fill under the line gives a sense of 'volume'
  geom_area(fill = "#8E44AD", alpha = 0.2) + 
  # The main trend line
  geom_line(color = "#8E44AD", size = 1.2) + 
  # Points to highlight specific days
  geom_point(color = "#8E44AD", size = 2) + 
  # Add trend line (smooth) to see the general direction
  geom_smooth(method = "loess", se = FALSE, color = "orange", linetype = "dashed", size = 0.8) +
  
  labs(
    title = "Daily Transaction Trends (Last 30 Days)",
    subtitle = "Purple line shows daily volume; Orange dashed line shows the moving average",
    x = "Date",
    y = "Number of Transactions"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1), # Tilts date labels so they don't overlap
    panel.grid.minor = element_blank()
  ) +
  scale_x_date(date_labels = "%b %d", date_breaks = "3 days") # Shows "Jan 01" format every 3 days

# 5. Save
print(plot)
ggsave("presentation_plots/5_daily_trend.png", plot, width = 10, height = 6)

# 6. Close Connection
dbDisconnect(conn)