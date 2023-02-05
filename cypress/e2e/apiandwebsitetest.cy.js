describe('My First Test', () => {
  it('Visits the resumesite', () => {
    cy.visit('resume.finsrud.cloud')
  })
})

describe('My second Test', () => {
      it('Test POST Request', () => {  
           cy.request({
            method: 'POST',
            url: 'https://functionappcloud.azurewebsites.net/api/visit/testpartitionkey/VISITOR',
            failOnStatusCode: false
           })
      })
      it('Test GET Request', () => {
        cy.request({
          method: 'POST',
            url: 'https://functionappcloud.azurewebsites.net/api/visit/testpartitionkey/VISITOR',
          failOnStatusCode: false
         })
     })
})