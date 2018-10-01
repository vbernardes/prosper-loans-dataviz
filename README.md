# udacity-dataviz-proj
Data Visualization project for Udacity Data Analyst course.

## Summary

Prosper is a peer-to-peer lending platform that allows investors to choose among personal loans requested by borrowers to invest in, considering credit scores, ratings, among other factors, which include a custom calculated *Prosper Score* that represents the risk for each loan. The higher the risk, the higher the interest rates paid by the borrower to the investors.

However, this visualization shows that, on average, loans with a *Prosper Score* of 2-4 (higher risk) had similar proportions of bad loans (defaulted loans, charged off loans or loans past due) as loans with a score of 6-8 (lower risk), even though their interest rate was significantly higher. In other words, investors who invested in loans with a score of 6-8 expected lower risk loans — and received lower rates in return — but ended up with risky loans just the same.

## Design

The following lists the initial design choices.

### Initial versions

#### Chart type

Since the visualization shows continuous data (mean interest rate and proportion of good/bad loans) for values of a categorical variable, I opted to use a bar chart.

#### Visual encodings

This visualization displays two basic bar charts. Since it is a chart type most readers are familiar with, for better readability, I chose to keep visual encodings to a minimum and rely more on the length of the bars to allow readers to view the variable values and to perform comparisons.

Bars were colored in light grey, allowing the use of color when needed to highlight certain aspects of the charts (see below).

Initially I had a few ideas on how to draw the reader’s attention to the bars I wanted to highlight. Those bars were crucial to helping them understand the message I was trying to convey with the visualization. These ideas included horizontal reference lines, coloring the bars, and adding annotations.  

For the first version of the visualization, I opted to use both annotations and to simultaneously color bars on both charts on mouse-over, to help the reader compare the interest rate and proportion of bad loans for a given Prosper Score.

Upon receiving feedback, I implemented the colors a little differently. Two bars (3 and 7) were colored in both charts from the start in order to highlight the discrepancies between risk and return I wanted to show with the visualization. Also, I kept annotations that helped convey that message.

#### Layout

Since both charts share the same variable (*Prosper Score*) on the x axis, I opted to display them on top of each other. That makes sure the bars for each Prosper Score are aligned directly on top of each other, allowing the reader to more easily understand the data being shown for each individual score and how it relates to the other adjacent scores.

Also, for clarity, I opted to remove gridlines.

## Feedback

**Feedback #1:**

- The charts were considered to convey their message well. However, the visualization summary was deemed confusing, and could use a rewrite for clarity.

**Feedback #2:**

- The mouse-over coloring feature was not considered to add much value to the visualization, so it was suggested that the chart instead contain fixed colors on some bars in order to highlight the intended message.

## Resources

In order to keep this file concise, please refer to the `References.txt` file for any external resources.