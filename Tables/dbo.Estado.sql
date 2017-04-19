CREATE TABLE [dbo].[Estado]
(
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Estado] ADD CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED  ([Cd_Est]) ON [PRIMARY]
GO
