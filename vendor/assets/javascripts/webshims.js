$.webshims.polyfill('forms forms-ext geolocation sticky es5 filereader');

$.webshims.setOptions('forms', {
    customMessages: true,
    replaceValidationUI: true
});

// Improve custom messages
$.webshims.validityMessages['en'] = {
    typeMismatch: {
        email: 'Please provide a valid email.',
        url: 'changed {%value} is not a valid web address',
        number: 'changed {%value} is not a number!',
        date: 'changed {%value} is not a date',
        time: 'changed {%value} is not a time',
        range: 'changed {%value} is not a number!',
        "datetime-local": 'changed {%value} is not a correct date-time format.'
    },
    rangeUnderflow: '{%value} is too low. The lowest value you can use is {%min}.',
    rangeOverflow: 'changed {%value} is too high. The highest value you can use is {%max}.',
    stepMismatch: 'changed The value {%value} is not allowed for this form. Only certain values are allowed for this field. {%title}',
    tooLong: 'changed The entered text is too large! You used {%valueLen} letters and the limit is {%maxlength}.',
    patternMismatch: 'changed {%value} is not in the format this page requires! {%title}',
    valueMissing: 'Please fill out this field.'
};