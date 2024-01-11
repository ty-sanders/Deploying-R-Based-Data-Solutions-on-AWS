library(tidyverse)
library(shiny)
library(janitor)
library(reactable)
library(bslib)
library(bsicons)
library(htmlwidgets)
library(shinyWidgets)
library(shinydashboard)
library(arrow)
library(slackr)
library(aws.s3)
library(jsonlite)
library(shinyauthr)
library(sodium)
library(shinyjs)
library(decor)



wdayvec <- c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
colors <- c("red", "blue")
data("mtcars")

# dataframe that holds usernames, passwords and other user data
user_base <- tibble::tibble(
  user = c("clawed"),
  password = sapply(c("go_eagles"), sodium::password_store),
  permissions = c("admin"),
  name = c("Clawed")
)


# Main login screen
loginpage <- div(id = "loginpage", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
                 wellPanel(
                     tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                     textInput("userName", placeholder="Username", label = tagList(icon("user"), "Username")),
                     passwordInput("passwd", placeholder="Password", label = tagList(icon("unlock-alt"), "Password")),
                     br(),
                     div(
                         style = "text-align: center;",
                         actionButton("login", "SIGN IN", style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
                         shinyjs::hidden(
                             div(id = "nomatch",
                                 tags$p("Oops! Incorrect username or password!",
                                        style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                                        class = "text-center"))),
                         br()
                    
                     ))
)


ui <- fluidPage(
  
  # login section
  shinyauthr::loginUI(id = "login"),
  
  # Sidebar to show user info after login
  uiOutput("body"),
  # logout button
  div(class = "pull-right", shinyauthr::logoutUI(id = "logout"))
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  

    credentials <- shinyauthr::loginServer(
      id = "login",
      data = user_base,
      user_col = user,
      pwd_col = password,
      sodium_hashed = TRUE,
      log_out = reactive(logout_init())
    )
    # Logout to hide
    logout_init <- shinyauthr::logoutServer(
        id = "logout",
        active = reactive(credentials()$user_auth)
    )
    
  
    output$logoutbtn <- renderUI({
      req(credentials()$user_auth)
      tags$li(a(icon("fa fa-sign-out"), "Logout", 
                  href="javascript:window.location.reload(true)"),
                class = "dropdown", 
                style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;")
    })
    
    
    output$body <- renderUI({
      req(credentials()$user_auth)
      fluidPage(
      textInput("Text", "Please insert some text", value = "text here"), 
      textAreaInput("textarea", "Insert a paragraph", value = ""), 
      numericInput("a number", "insert a number", value = 0, min =  0, max = 10, step = 1),
      sliderInput("slider1", "Insert a number",
                  min = 0, max = 10, value = c(5, 7), animate = TRUE),
      dateInput("adate", "insert a date please"),
      dateRangeInput("drange", "insert a date range"),
      selectInput("dayofweek", "What day is it", choices = wdayvec),
      radioButtons("dayofweek2", "what day is it?", choices = wdayvec),
      checkboxGroupInput("dayofweek3", "What day were you born", choices = wdayvec, inline = TRUE),
      varSelectInput("varname", "Which Column", data = mtcars),
      checkboxInput("checkbox", "Do you like star trek", value = TRUE),
      fileInput("filename", "what file"),
      actionButton("button", "Click Me!"),
      textInput("tex", "add a to ..."),
      textOutput("aadded"),
      plotOutput("plot"),
      varSelectInput("var1", "Variable 1", data = mtcars),
      varSelectInput("var2", "Variable 2", data = mtcars),
      plotOutput("plotz"),
      radioButtons("redorblue", "pick point color", choices = colors),
      
      
      
      
      
      
    )
})

      output$aadded <- renderText({
        input$tex
      })
      output$plot <- renderPlot({
        ggplot(mpg, aes(x = displ, y = hwy)) +
          geom_point() +
          theme_bw() +
          xlab("Displacement") +
          ylab("Highway MPG")
      })
      output$plotz <- renderPlot({
        ggplot(mtcars, aes(x = !!input$var1, y = !!input$var2, color = input$redorblue)) +
          geom_point(color = input$redorblue) +
          xlab("Plot 2 Variables")
        
      })
}
    

shinyApp(ui = ui, server = server)
