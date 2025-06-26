# RAM-3737

## Abstract
This story is about doing the backend story for loan payoff data where we are going to proxy through the data from
the iSeries concerning [[payoff-loan-data]]

This is probably going to go on the home details object or some object there of.

Service>Adapter>Client

determine what the domain model needs
what sort of object

determine the abstraction that your service needs.
just the interface

(
Domain package
create domain data model (which represents what the service needs)

2. create the api client which exposes what data is actually available. (infrastructure)

3. create the adapater itself

create the adapater
inject it into the constrcutor

infra
go make your iseries client

)
    ----------
07/23/25

go back and untrack the loan DTO object from git.
go back and untrack the domain obejct as well (untrack and delete

Make the dtos for the domain and also for the package (these should olok similar
(change the controller so that it has proper naming conventions and also properly referencing the dtos)
(need to change something in the api.client later on so that it all matches)

come back and finish modeling the PayoffInformation resposne
Come back and finish the appsettings json ✅

## Directory

## Useful Links

## Tags

[[payoff-loan-data]]
