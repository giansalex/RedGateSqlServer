CREATE TABLE [dbo].[ContactoxDocumento]
(
[Id_ContactoxDoc] [int] NOT NULL IDENTITY(1, 1),
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDES] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Codigo] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_Gen] [int] NOT NULL,
[CorreoEnviado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ContactoxDocumento] ADD CONSTRAINT [PK_ContactoxDocumento] PRIMARY KEY CLUSTERED  ([Id_ContactoxDoc]) ON [PRIMARY]
GO
