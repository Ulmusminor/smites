library(shiny)
library(bslib)

# Define UI ----
ui <- page_navbar(
  title = "Spider Mites",
  nav_panel(
    title = "Instructions",
    card(
      HTML("
      <p>This webpage is designed in order to aid with the study of 
      spider mite distribution in preference tests. The webpage is 
      able to do three things:</p>
      <ul>
        <li>Give orders about the layout for the preference tests 
        (in order to attempt to single-blind the study), although 
        this step may be skipped;</li>
        <li>Interpret result files from excel or .txt if they are 
        properly formatted and give a summary of the results;</li>
        <li>Perform some statistical analysis.</li>
      </ul>
      <p> The format for reading the files should be as follows:
      a .txt with the following layout:</p>
    "),
    ),
    card(
      card_image(
        "exampletxt.png",
        style = "width:50%;height:auto;"
      )
    )
  ),
  nav_panel(
    title = "Before the Experiment",
    card(
      helpText(
        "Please introduce the number of spider mites that are going to
        be observed through the whole week:"
      ),
      numericInput(
        "number",
        "Number of mites (multiples of 20 are preferred)",
        value = 1
      ),
      "Layout",
      textOutput("selected_num"),
      ""
    )
  ),
  nav_panel(
    title = "After the Experiment", 
    card(
      card_header("File loading and Basic analysis"),
      helpText(
        "Please introduce a file with the results for the week. Make
        sure that the file suits one of the formats described in the
        instructions"
      ),
      fileInput("file", label = NULL),
      textOutput("summary"),
    ),
    card(
      card_header("Complex analysis"),
      textOutput("tstudent"),
      textOutput("glm model"),
      textOutput("diagnostics")
    )
  )
)
# Define server logic ----
server <- function(input, output) {
  output$selected_num <- renderText({
    paste("You have selected", input$number, "mites [This is meant to show the 
          layout for the mites. Here I could make an option to design the usual
          layout or to make a randomized one instead]")
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)