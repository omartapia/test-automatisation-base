Feature: Escenarios para la API de personajes de Marvel

  Background:
    * url 'http://localhost:8080/otapiahi/api/characters'
    * configure headers = { 'Content-Type': 'application/json' }
    * def characterSchema =
  """
  {
    id: '#number',
    name: '#string',
    alterego: '#string',
    description: '#string',
    powers: '#[]'
  }
  """

  Scenario: Obtener todos los personajes
    When method get
    Then status 200
    And match response == [] || response == '#[] characterSchema'

  Scenario: Crear personaje exitosamente
    * def body = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    Given request body
    When method post
    Then status 201
    And match response == characterSchema

  Scenario: Obtener personaje por ID (exitoso)
    Given path '1'
    When method get
    Then status 200
    And match response == characterSchema

  Scenario: Obtener personaje por ID (no existe)
    Given path '999'
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Crear personaje (nombre duplicado)
    * def body = { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    Given request body
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Crear personaje (faltan campos requeridos)
    * def body = { name: '', alterego: '', description: '', powers: [] }
    Given request body
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  Scenario: Actualizar personaje (exitoso)
    * def body = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    Given path '1'
    And request body
    When method put
    Then status 200
    And match response.description == 'Updated description'
    And match response == characterSchema

  Scenario: Actualizar personaje (no existe)
    * def body = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    Given path '999'
    And request body
    When method put
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar personaje (exitoso)
    Given path '1'
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path '999'
    When method delete
    Then status 404
    And match response.error == 'Character not found'
