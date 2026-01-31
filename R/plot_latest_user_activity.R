#Setup Folder and Connection
dir.create("presentation_plots", showWarnings = FALSE)
conn <- dbConnect(RSQLite::SQLite(), "pezesha_data.db")

query <- "
SELECT *
FROM transactions t1
WHERE transaction_date = (
    SELECT MAX(transaction_date)
    FROM transactions t2
    WHERE t2.user_id = t1.user_id
)
"
df_latest <- dbGetQuery(conn, query)

#Process Data for Plotting
#Convert text date to actual Date object
df_latest$transaction_date <- as.POSIXct(df_latest$transaction_date)
# Handle NULL categories for cleaner legend
df_latest$category <- ifelse(is.na(df_latest$category), "Unclassified", df_latest$category)

#Create Timeline Scatter Plot
plot <- ggplot(df_latest, aes(x = transaction_date, y = amount, color = category)) +
  geom_point(alpha = 0.7, size = 3) + 
  scale_y_log10(labels = comma) + 
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "User Recency Snapshot",
    subtitle = "Each dot represents a user's most recent transaction",
    caption = "Y-axis is on a Log Scale to show wide range of values",
    x = "Date of Last Transaction",
    y = "Amount (KES) [Log Scale]",
    color = "Category"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

# 5. Save
print(plot)
ggsave("presentation_plots/4_latest_activity_scatter.png", plot, width = 10, height = 6)

# 6. Close Connection
dbDisconnect(conn)