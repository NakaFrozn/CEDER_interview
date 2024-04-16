###############################################################################
# Project Title: GeT Support Evaluation 2021
# 
# Data processing stage: analysis of individuals in network - visualization
#
#
# Used datasets:       "./output/visualizations.dta"
#                     
#
# Merged datasets:     None
#
# Saved datasets:      
#
# created by: ESSJ on 13 Nov 2021
# modified by: ABC on dd mm yyyy
# modification notes: enter note here
#
# reviewed by: ABC on dd mm yyyy
#
# To do: Keep a running list of stuff to do here
###############################################################################

###############################################################################
## Preliminaries
###############################################################################
#set working directory
setwd("/Users/liz/Dropbox (University of Michigan)/GeT Support/Year 4 of 5 2020_2021/5-Analysis and reporting/5-data_analysis")

#read a few necessary libraries for convenience
library(statnet)
library(tidyverse)
library(haven)
library(showtext)
font_add(family="franklin gothic book", regular="/Users/liz/Library/Fonts/Franklin Gothic Book Regular.ttf")

data=read_dta( "./output/visualizations.dta") 
  

###############################################################################
## changes in individual ratings of overall benefit 
###############################################################################

benefit <- data %>% 
  select(name, overall, year) %>% 
  pivot_wider(names_from = year, values_from = overall) %>% 
  rename(pre = "2020", post = "2021") %>% 
  
#gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

benefit %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:5), 
                     labels = c("Strongly Disagree", " ", "Neither Disagree nor Agree", 
                                " ", "Strongly Agree"),
                     limits = c(0.5, 5.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0.1, 1.1)) +
  #ggtitle("Perceptions of connections were unchanged") +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post), color = "#F6652D", size = .5) +
  geom_point(aes(x = 0, y = pre), color = "#F6652D", size = .5) +
  geom_point(aes(x = 1, y = post), color = "#F6652D", size = .5) +
  #scale_color_manual(values=c("#F6652D", "#767676")) + -- only need this when we want diff color/size lines
  #scale_size_manual(values = c(1,0.25)) +
  labs(title = "Benefit from Network Participation") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/overall_ind.jpg")

##dumbbell plot for interactions - presenting 
int_present <- data %>% 
  select(name, year, int_present, change) %>% 
  pivot_wider(names_from = year, values_from = int_present) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_present %>% 
  ggplot() +
  scale_y_continuous(breaks = seq(0,12,2), #THIS IS THE KEY
                     #labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " ", "12"),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0.1, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(0.25,0.25)) +
  labs(title = "Interaction: Planned Presentation") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_present.jpg")

##dumbbell plot for interactions - newlestter
int_newsletter <- data %>% 
  select(name, year, int_newsletter, change) %>% 
  pivot_wider(names_from = year, values_from = int_newsletter) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_newsletter %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:12), 
                     labels = c("0", " ", "2", " ", 4, " ", 6, " ", 8, " ", 10, " "),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0.1, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(0.25,0.25)) +
  labs(title = "Interaction: Worked on Newsletter") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_newsletter.jpg")

##dumbbell plot for interactions - newlestter
int_instructional <- data %>% 
  select(name, year, int_instructional, change) %>% 
  pivot_wider(names_from = year, values_from = int_instructional) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_instructional %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:12), 
                     labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " "),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(.25,0.25)) +
  labs(title = "Interaction: Developed Instructional Resource") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_instructional.jpg")

##dumbbell plot for interactions - wg mtg
int_wg_mtg <- data %>% 
  select(name, year, int_wg_mtg, change) %>% 
  pivot_wider(names_from = year, values_from = int_wg_mtg) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_wg_mtg %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:13), 
                     labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " ", "12"),
                     limits = c(-0.5, 13.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(.25,0.25)) +
  labs(title = "Interaction: Working Group Meeting") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_wg_mtg.jpg")

##WHY ARE MY VALUES SLIGHTLY NOT-ALIGNED? 

##dumbbell plot for interactions - in person mtg
int_inperson_mtg <- data %>% 
  select(name, year, int_inperson_mtg, change) %>% 
  pivot_wider(names_from = year, values_from = int_inperson_mtg) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_inperson_mtg %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:12), 
                     labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " "),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(.25,0.25)) +
  labs(title = "Interaction: In Person Meeting") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_inperson_mtg.jpg")


##dumbbell plot for interactions - forum
int_forum <- data %>% 
  select(name, year, int_forum, change) %>% 
  pivot_wider(names_from = year, values_from = int_forum) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_forum %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:12), 
                     labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " "),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(.25,0.25)) +
  labs(title = "Interaction: Forum") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_forum.jpg")

##dumbbell plot for interactions - talk
int_talk <- data %>% 
  select(name, year, int_talk, change) %>% 
  pivot_wider(names_from = year, values_from = int_talk) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_talk %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:12), 
                     labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " "),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(.25,0.25)) +
  labs(title = "Interaction: Talked Informally") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_talk.jpg")

##dumbbell plot for interactions - support
int_support <- data %>% 
  select(name, year, int_support, change) %>% 
  pivot_wider(names_from = year, values_from = int_support) %>% 
  rename(pre = "2020", post = "2021") %>% 
  mutate(change = as_factor(change)) %>% 
  
  #gotta add a common random number to pre and post because geom_segment doesn't jitter well
  mutate(rand = rnorm(n = nrow(.), mean = 0, sd = .1)) %>%
  mutate(pre = pre + rand) %>%
  mutate(post = post + rand) 

showtext_auto()

int_support %>% 
  ggplot() +
  scale_y_continuous(breaks = c(1:12), 
                     labels = c("0", " ", "2", " ", "4", " ", "6", " ", "8", " ", "10", " "),
                     limits = c(-0.5, 12.5)) +
  scale_x_continuous(breaks = c(0, 1), labels = c("2020", "2021"), limits = c(-0, 1.1)) +
  geom_segment(aes(x = 0, y = pre, xend = 1, yend = post, color = change, size = change)) +
  geom_point(aes(x = 0, y = pre, color = change, size = change)) +
  geom_point(aes(x = 1, y = post, color = change, size = change)) +
  scale_color_manual(values=c("#F6652D", "#767676")) + 
  scale_size_manual(values = c(.25,0.25)) +
  labs(title = "Interaction: Sought Support") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Franklin Gothic Book",
                            face = "plain",
                            colour = "#767676"),
        axis.text = element_text(size = 12,
                                 colour = "#767676"),
        strip.text = element_text(size = 12,
                                  family = "Franklin Gothic Book",
                                  colour = "#767676"),
        title = element_text(size = 12),
        axis.title = element_blank(),
        legend.position = "none")

ggsave("./output/interactions_support.jpg")