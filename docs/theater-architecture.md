# Theater architecture

This page outlines the core runtime objects and how the server, client, and embedded browser cooperate.

## Runtime overview

The server owns theater state and queue decisions. Clients provide the UI and embedded media player.

```mermaid
flowchart TD
    Map[Map location data] --> Location[Location registry]
    Location --> Theater[THEATER instances]
    UI[Client request UI] --> Request[THEATER RequestVideo]
    Request --> Service[SERVICE matching]
    Service --> Metadata[VIDEO metadata]
    Metadata --> Queue[Server queue]
    Queue --> Select[NextVideo]
    Select --> Active[SetVideo]
    Active --> Net[TheaterVideo message]
    Net --> Player[Client DHTML player]
```
