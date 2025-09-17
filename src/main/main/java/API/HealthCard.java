package API;

public class HealthCard {
	private String title;
    private String category; // Low, Moderate, High, Extreme
    private String bgColor;  // Tailwind class: bg-green-100, bg-yellow-100, etc.
    private String textColor; // text-green-800, etc.
    private String advice;

    public HealthCard(String title, String category, String bgColor, String textColor, String advice) {
        this.title = title;
        this.category = category;
        this.bgColor = bgColor;
        this.textColor = textColor;
        this.advice = advice;
    }

    // Getters
    public String getTitle() { return title; }
    public String getCategory() { return category; }
    public String getBgColor() { return bgColor; }
    public String getTextColor() { return textColor; }
    public String getAdvice() { return advice; }

}
