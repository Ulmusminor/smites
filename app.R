library(shiny)
library(bslib)
library(tidyverse)

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
      
      selectInput(inputId = "y", label = "Table",
                  choices = c("Position", "Eggs Left", "Eggs Right")),
      
      tableOutput("mites"),
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
  
  data <- reactive({
    list(
      pos = input$file$datapath |> 
      read_table( 
               col_names = c("Hours", paste("Mite", 1:20)), 
               col_types = cols(.default = "c"), 
               skip = 4, n_max = 5) |> 
      pivot_longer(-Hours, names_to = "Number") |>    
      pivot_wider(names_from = Hours, values_from = value),
    
    l = input$file$datapath |> 
      read_table( 
        col_names = c("Hours", paste("Mite", 1:20)), 
        col_types = cols(.default = "c"), 
        skip = 11, n_max = 5) |> 
      pivot_longer(-Hours, names_to = "Number") |>    
      pivot_wider(names_from = Hours, values_from = value),
    
    r = input$file$datapath |> 
      read_table( 
        col_names = c("Hours", paste("Mite", 1:20)), 
        col_types = cols(.default = "c"), 
        skip = 18, n_max = 5) |> 
      pivot_longer(-Hours, names_to = "Number") |>    
      pivot_wider(names_from = Hours, values_from = value)
    )
  })
  
  output$mites <- renderTable({
    if (is.null(input$file)) return(tibble(Message = "No file uploaded yet"))
    else if (input$y == "Position") return(data()$pos)
    else if (input$y == "Eggs Left") return(data()$l)
    else return(data()$r)
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)
