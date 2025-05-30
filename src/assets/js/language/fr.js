/**
 * NUKEVIET Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

var nv_aryDayName = "Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi".split(" "),
    nv_aryDayNS = "Dim Lun Mar Mer Jeu Ven Sam".split(" "),
    nv_aryMonth = "Janvier Février Mars Avril Mai Juin Juillet Aout Septembre Octobre Novembre Decembre".split(" "),
    nv_aryMS = "Jan Fév Mar Avr Mai Jun Jul Aout Sep Oct Nov Dec".split(" "),
    nv_admlogout_confirm = ["Êtes-vous sûr de vouloir quitter l'Administration?", "Toutes les informations de votre session ont été supprimées. Vous avez quitté l'Administration"],
    nv_is_del_confirm = ["Êtes-vous sûr de vouloir supprimer? Si vous acceptez, toutes les données seront supprimées, il est impossible de les restauter.", "Suppression réussie", "Suppression échouée"],
    nv_is_change_act_confirm = ["Êtes-vous sûr de vouloir 'changer'?", " 'Changement' réussi", " 'Changement' échoué"],
    nv_is_empty_confirm = ["Êtes-vous sûr de vouloir 'vider'?", " 'vider' avec succès", " 'vider' échoué pour une raison inconnue"],
    nv_is_recreate_confirm = ["Êtes-vous sûr de vouloir 'ré-installer'?", " 'Ré-installation' réussie", "'Ré-installation' échouée pour une raison inconnue"],
    nv_is_add_user_confirm = ["Êtes-vous sûr de vouloir ajouter les nouveaux membres au groupe?", "'Ajout' de nouveaux membres au groupe avec succcès", " 'Ajout ' échoué pour une raison inconnue"],
    nv_is_exclude_user_confirm = ["Êtes-vous sûr de vouloir éliminer ce membre?", "'Élimination' réussie", " 'Élimination  échouée pour une raison inconnue"],
    nv_gotoString = "Aller au mois actuel",
    nv_todayString = "Aujourd'hui c'est",
    nv_weekShortString = "Semaine",
    nv_weekString = "par semaine",
    nv_scrollLeftMessage = "Cliquez pour aller au mois précédant. Enfoncez le bouton du souris pour enrouler automatiquement.",
    nv_scrollRightMessage = "Cliquez pour aller au mois suivant. Enfoncez le bouton du souris pour enrouler automatiquement.",
    nv_selectMonthMessage = "Cliquez pour sélectionner un mois.",
    nv_selectYearMessage = "Cliquez pour sélectionner un an.",
    nv_selectDateMessage = "Sélectionnez [date] comme date.",
    nv_loadingText = "Chargement...",
    nv_loadingTitle = "Cliquez pour annuler",
    nv_focusTitle = "Cliquez pour mettre au premier plan",
    nv_fullExpandTitle = "Expandre à la taille réelle (f)",
    nv_restoreTitle = "Cliquez pour fermer l'image, Cliquez et glissez pour déplacer. Utilisez les flèches pour Précédente et Suivante.",
    nv_error_login = "Erreur: Vous n'avez pas rempli votre compte ou les infos du compte sont incorrectes. Le compte se combine de lettres latines, de chiffres et tiret. Maximum [max], minimum [min] caractères.",
    nv_error_password = "Erreur: Vous n'avez pas rempli le mot de passe ou le mot de passe n'est pas correct. Le mot de passe se combine de lettres latines, de chiffres et tiret. Maximum [max], minimum [min] caractères.",
    nv_error_email = "Erreur: Vous n'avez pas entré votre e-mail ou l'e-mail n'est pas correct.",
    nv_error_seccode = "Erreur: Vous n'avez pas entré le code de sécurité ou le code n'est pas correct. Code de sécurité est une série de [num] caractères affichées en image.",
    nv_login_failed = "Erreur: Le système n'accepte pas votre compte. Essayez de nouveau.",
    nv_content_failed = "Erreur: Le système n'accepte pas les infos. Essayez de nouveau.",
    nv_required = "Ce champ est obligatoire.",
    nv_remote = "Merci de corriger ce champ.",
    nv_email = "Merci d'entrer un e-mail valide.",
    nv_url = "Merci de donner un lien valide.",
    nv_date = "Merci de donner une date valide.",
    nv_dateISO = "Merci de donner une date valide (ISO).",
    nv_number = "Merci d'entrer un nombre valide.",
    nv_digits = "Merci d'entrer uniquement les chiffres.",
    nv_creditcard = "Merci d'entrer un numéro valide de carte bancaire.",
    nv_equalTo = "Merci d'entrer la même valeur encore une fois.",
    nv_accept = "Merci d'entrer une valeur avec extension valide.",
    nv_maxlength = "Merci de ne pas entrer plus de {0} caractères.",
    nv_minlength = "Merci d'entrer au minimum {0} caractères.",
    nv_rangelength = "Merci d'entrer une valeur entre {0} et {1} caractères.",
    nv_range = "Merci d'entrer une valeur entre {0} et {1}.",
    nv_max = "Merci d'entrer une valeur moins ou égale à {0}.",
    nv_min = "Merci d'entrer une valeur plus ou égal à {0}.",
    //contact
    nv_fullname = "Nom complet entré n'est pas valide.",
    nv_title = "Titre invalide.",
    nv_content = "Contenu vide.",
    nv_code = "Code de sécurité incorrect.",
    nv_close = "Fermer",
    nv_confirm = "Confirmer",
    nv_please_check = "Veuillez sélectionner au moins une ligne",
    // Message before unload
    nv_msgbeforeunload = "Les données ne sont pas enregistrées. Vous perdrez toutes les données si vous quittez cette page. Veux-tu partir?",
    // ErrorMessage
    verify_not_robot = "Veuillez vérifier que vous n'êtes pas un robot",
    NVJL = [];
NVJL.errorRequest = "Il y a eu une erreur avec la demande.";
NVJL.errortimeout = "La demande a expiré.";
NVJL.errornotmodified = "La requête n'a pas été modifiée mais n'a pas été extraite du cache.";
NVJL.errorparseerror = "Le format XML/Json est mauvais.";
NVJL.error304 = "Non modifié. Le client demande un document qui est déjà dans son cache et le document n'a pas été modifié depuis sa mise en cache. Le client utilise la copie mise en cache du document au lieu de la télécharger à partir du serveur.";
NVJL.error400 = "Mauvaise demande";
NVJL.error401 = "Non autorisé";
NVJL.error403 = "Interdit";
NVJL.error404 = "Ina pas trouvé";
NVJL.error406 = "Inacceptable";
NVJL.error500 = "Erreur de serveur interne";
NVJL.error502 = "Bad Gateway";
NVJL.error503 = "Service indisponible";

var nukeviet = nukeviet || {};
nukeviet.i18n = nukeviet.i18n || {};
nukeviet.i18n.WebAuthnErrors = {
    creat: {
        NotAllowedError: 'Vous avez refusé la demande',
        ConstraintError: 'Une contrainte dans la configuration de la demande n\'est pas satisfaite',
        InvalidStateError: 'Cette clé a déjà été enregistrée, veuillez créer une autre clé',
        TypeError: 'Un paramètre dans la demande est invalide, veuillez recharger la page et réessayer',
        SecurityError: 'Un problème de sécurité est survenu lors de l\'enregistrement, veuillez recharger la page et réessayer',
        AbortError: 'Vous avez annulé la demande',
        NotSupportedError: 'Le navigateur ou l\'appareil ne prend pas en charge WebAuthn ou le paramètre spécifique demandé',
        NotReadableError: 'Impossible de lire les données depuis l\'appareil d\'authentification',
        NotFoundError: 'Aucun appareil d\'authentification approprié trouvé ou aucun appareil prêt pour la demande',
        DataError: 'Une erreur est survenue dans les données fournies',
        OperationError: 'Erreur interne lors de l\'authentification, vérifiez le navigateur ou l\'appareil',
        TimeoutError: 'Le processus d\'authentification a pris trop de temps, veuillez recharger la page et réessayer',
        InvalidAccessError: 'Accès illégal et bloqué'
    },
    get: {
        NotAllowedError: 'Vous avez refusé la demande d\'authentification',
        SecurityError: 'La demande n\'est pas sécurisée et ne peut pas être effectuée, veuillez recharger la page et réessayer',
        TimeoutError: 'Le processus d\'authentification ou d\'enregistrement a expiré',
        AbortError: 'Vous avez annulé la demande',
        NotSupportedError: 'Le navigateur ou l\'appareil ne prend pas en charge WebAuthn',
        ConstraintError: 'Les contraintes (par exemple : userVerification) ne sont pas satisfaites, veuillez recharger la page et réessayer',
        InvalidStateError: 'État invalide (par exemple : PublicKeyCredential a été annulé), veuillez recharger la page et réessayer',
        EncodingError: 'Erreur liée au codage des données (par exemple : Base64 URL-encoded invalide), veuillez recharger la page et réessayer'
    },
    unknow: 'Erreur inconnue, veuillez recharger la page et réessayer'
};
nukeviet.i18n.errorSessExp = 'La session a expiré ou une autre erreur s\'est produite, veuillez recharger la page et réessayer';
nukeviet.i18n.close = 'Fermer';
nukeviet.i18n.seccode1 = 'Vérification &quot;Je ne suis pas un robot&quot;';
nukeviet.i18n.seccode = 'Code de sécurité';
nukeviet.i18n.captcharefresh = 'Rafraîchir';
