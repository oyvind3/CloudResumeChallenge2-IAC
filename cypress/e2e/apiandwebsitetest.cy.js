describe('My First Test', () => {
  it('Visits the resumesite', () => {
    cy.visit('https://resume.finsrud.cloud/')
  })
})

describe('My second Test', () => {
  it('Test GET Request', () => {
       cy.request({
        method: 'GET',
        url: 'https://oyvindfunction3001.azurewebsites.net/api/visit/testpartitionkey/VISITOR',
        failOnStatusCode: false
      })
  })
})

describe('My third Test', () => {
  it('Test POST Request', () => {  
       cy.request({
        method: 'POST',
        url: 'https://oyvindfunction3001.azurewebsites.net/api/visit/testpartitionkey/VISITOR',
        failOnStatusCode: false
       })
  })
})