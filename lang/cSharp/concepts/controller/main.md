# C Sharp Controller

## Abstract
In ASP.NET Core MVC, a controller is a class that handles incoming HTTP requests, processes them, and returns
responses. Controllers are a fundamental part of the MVC (Model-View-Controller) pattern, where:

Model represents the data and business logic.
View is the user interface.
Controller handles the user input and interacts with the model to render the appropriate
view. Controllers contain action methods that respond to HTTP requests. These methods typically interact with models
to retrieve or update data and then return views or data directly 1 2.

example:
```c sharp
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace Cmh.Vmf.Rmktg.HomeBaseGateway.Api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class LoansController : BaseController<Guid>
    {
        private readonly ILoanService _loanService;
        private readonly ILogger _logger;
        private readonly LoanPayoffDetailsMapper _loanPayoffDetailsMapper;

        public LoansController(ILogger<LoansController> logger, ILoanService loanService, LoanPayoffDetailsMapper loanPayoffDetailsMapper)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _loanService = loanService ?? throw new ArgumentNullException(nameof(loanService));
            _loanPayoffDetailsMapper = loanPayoffDetailsMapper ?? throw new ArgumentNullException(nameof(loanPayoffDetailsMapper));
        }
        [HttpGet("/{accountId}/payoffdetails")]
        [ProducesResponseType(typeof(Dto.LoanPayoffDetails), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetLoanPayoffDetailsAsync(string accountId)
        {
            _logger.LogInformation($"Recieved GET request for Loan Payoff Details with Account ID '{accountId}'");
            var parsedId = ParseGuid(accountId);

            var payoffDetails = await _loanService.GetPayoffDetailsByAccountAsync(parsedId);

            return Ok(_loanPayoffDetailsMapper.Map(payoffDetails));
        }
    }
}
```
## Directory

## Useful Links

## Tags
