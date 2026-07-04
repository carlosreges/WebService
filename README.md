# Credential Verification Service (Salesforce)

## Descripción del Proyecto
Este proyecto implementa un servicio web SOAP robusto dentro del ecosistema Salesforce para la validación en tiempo real de certificaciones de contactos. Fue desarrollado para resolver la necesidad de verificar la validez y el estado de vigencia de las credenciales de los usuarios de manera automatizada.

## Características Técnicas
- **Tecnología Principal:** Salesforce Apex.
- **Protocolo:** SOAP Web Services (`webservice`).
- **Lógica de Negocio:** Consultas complejas mediante SOQL para verificar relaciones entre `Contact` y `Contact_Certification__c`.
- **Validación:** Manejo de estados de certificación (Activo/Inactivo) y retorno de mensajes de estado precisos.
- **Calidad:** Cobertura de tests superior al 90% (Apex Testing Framework), garantizando la integridad de los datos y el cumplimiento de los requisitos.

## Tecnologías Utilizadas
- **Lenguaje:** Apex[cite: 2].
- **Consultas:** SOQL[cite: 2].
- **Entorno:** Salesforce Lightning Platform[cite: 2].
- **Integración:** SOAP API.

## Retos Superados
- Implementación de lógica de búsqueda dinámica que evita dependencias de campos Auto-Number mediante el uso de relaciones (Lookup) entre objetos.
- Optimización de la consulta SOQL para asegurar una ejecución eficiente y conforme a las mejores prácticas de Salesforce.
- Gestión de respuestas para casos de "No record found" vs "Needs Renewal" o "Valid", asegurando una integración fluida con sistemas externos.

## Instrucciones de Despliegue
1. Clonar este repositorio.
2. Autorizar la org de Salesforce utilizando Salesforce CLI.
3. Desplegar los componentes mediante `SFDX: Deploy Source to Org`.
4. Ejecutar las clases de test incluidas para verificar la integridad del servicio.
